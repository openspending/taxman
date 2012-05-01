fs = require 'fs'
taxman = require '../../taxman'
uk_tax_data = require './data'

zip = (arr1, arr2) ->
  for i in [0...Math.min(arr1.length, arr2.length)]
    [arr1[i], arr2[i]]

# Perform a linear interpolation using data points in 'data' (in the format
# [[x1, y1], [x2, y2], ..., [xN, yN]]) given an x value 'x'. Will throw an
# exception unless x1 <= x <= xN.
interpolate_linear = (data, x) ->
  if not (data[0][0] <= x <= data[-1...][0][0])
    throw "Attempt to interpolate outside data range!"

  for i in [0...data.length]
    [x0, y0] = data[i]
    [x1, y1] = data[i+1]
    if x0 <= x <= x1
      return y0 + ((y1 - y0)/(x1 - x0)) * (x - x0)

calc_allowances = (allowances, gross) ->
  res = {}
  deduction = 0

  if allowances.personal_income_limit?
    deduction = Math.floor(Math.max(0, gross - allowances.personal_income_limit) / 2)
    deduction = Math.min(deduction, allowances.personal)

  res.personal = allowances.personal - deduction
  res.total = res.personal # TODO: implement age-related allowances
  return res

calc_income_tax = (it, taxable) ->
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(it.bands, taxable)
  return res

calc_national_insurance = (ni, taxable) ->
  bands = [
    {width: ni.pt, rate: 0.0}
    {width: ni.uel - ni.pt, rate: ni.mcr}
    {rate: ni.acr}
  ]
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(bands, taxable)
  return res

calc_indirects = (indirects, income) ->
  res = {
    message: "These are estimated values of indirect tax payments based on Office of National Statistics figures."
  }

  getval = (key) ->
    min = indirects.income[0]
    max = indirects.income[-1...][0]
    if income < min
      return (indirects[key][0] / min) * income
    else if income > max
      return (indirects[key][-1...][0] / max) * income
    else
      return interpolate_linear(zip(indirects.income, indirects[key]), income)

  for own key, val of indirects
    if key.indexOf('indirects_') == 0
      res[key[10...]] = Math.floor(getval(key))

  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null
  opts.indirects = if query.indirects? then true else null

  for k in ['allowances', 'income_tax', 'national_insurance']
    data[k] = uk_tax_data[k][opts.year] if uk_tax_data[k][opts.year]?

  if opts.indirects
    data.indirects = uk_tax_data.indirects[opts.year] if uk_tax_data.indirects[opts.year]?

  if opts.income?
    if data.allowances?
      calc.allowances = calc_allowances(data.allowances, opts.income)
      calc.taxable = Math.max(0, opts.income - calc.allowances.total)

    if data.income_tax? and calc.taxable?
      calc.income_tax = calc_income_tax(data.income_tax, calc.taxable)

    if data.national_insurance?
      calc.national_insurance = calc_national_insurance(data.national_insurance, opts.income)

    if opts.indirects
      calc.indirects = calc_indirects(data.indirects, opts.income)

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
