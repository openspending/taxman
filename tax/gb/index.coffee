fs = require 'fs'
taxman = require '../../taxman'
uk_tax_data = require './data'

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

exports.calculate = (query) ->
  opts = {
    year: new Date().getFullYear()
  }
  data = {}
  calc = {}

  opts.year = parseInt(query.year, 10) if query.year?
  opts.income = parseInt(query.income, 10) if query.income?

  for k in ['allowances', 'income_tax', 'national_insurance']
    data[k] = uk_tax_data[k][opts.year] if uk_tax_data[k][opts.year]?

  if opts.income?
    if data.allowances?
      calc.allowances = calc_allowances(data.allowances, opts.income)
      calc.taxable = Math.max(0, opts.income - calc.allowances.total)

    if data.income_tax? and calc.taxable?
      calc.income_tax = calc_income_tax(data.income_tax, calc.taxable)

    if data.national_insurance?
      calc.national_insurance = calc_national_insurance(data.national_insurance, opts.income)

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
