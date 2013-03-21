fs = require 'fs'
taxman = require '../../taxman'
uk_tax_data = require './data'
documentation = require './documentation'

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

# Personal allowance tapering.
#
# 1) For every £2 of income above the personal allowance income limit
#    (which has existed since 2010-11), the personal allowance decreases
#    by £1, all the way to zero.
#
# 2) For every £2 of income above the age-related allowance limit, the
#    age-related allowance reduces by £1.
taper_deduction = (income, income_limit, max_deduction, factor=2) ->
  Math.min(max_deduction, Math.floor(Math.max(0, income - income_limit) / factor))

calc_allowances = (allowances, income, opts={}) ->
  res = {}
  res.personal = allowances.personal

  # Personal allowance tapering. For every £2 of income above the personal
  # allowance income limit (which has existed since 2010-11), the personal
  # allowance decreases by £1, all the way to zero
  if allowances.personal_income_limit?
    res.personal -= taper_deduction(income, allowances.personal_income_limit, res.personal)

  res.blind = if opts.blind then allowances.blind else 0
  res.age_related = 0

  if opts.age?
    if opts.year >= 2013
      # In 2013 the tax code for age-related allowances changed, so that only
      # those born before 6 Apr 1948 were eligible. We're not going to fuss
      # about days and months, so estimate by year.
      birth_year = opts.year - opts.age
      if 1938 <= birth_year < 1948
        res.age_related = allowances.born_apr_1938_to_apr_1948
      else if birth_year < 1938
        res.age_related = allowances.born_before_apr_1938
    else
      if 65 <= opts.age < 75
        res.age_related = allowances.aged_65_to_74
      else if opts.age >= 75
        res.age_related = allowances.aged_75_plus

    res.age_related -= taper_deduction(income, allowances.aged_income_limit, res.age_related)

  res.total = res.personal + res.blind + res.age_related
  return res

calc_income_tax = (it, taxable) ->
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(it.bands, taxable)
  return res

calc_national_insurance = (ni, income, opts) ->
  # People above state pension age pay no NI: >= 65 is not actually correct in
  # general, but it's a close enough approximation for the time being.
  if opts.age? and opts.age >= 65
    return {total: 0, bands: [0, 0]}

  bands = [
    {width: ni.pt, rate: 0.0}
    {width: ni.uel - ni.pt, rate: ni.mcr}
    {rate: ni.acr}
  ]

  tax = taxman.tax_in_bands(bands, income)
  res =
    total: tax[0]
    # The first band is zero-rated, so no tax will ever be paid in it.
    # Let's get rid of it:
    bands: tax[1][1...]

  return res

calc_indirects = (indirects, income) ->
  res = {}

  getval = (key) ->
    min = indirects.income[0]
    max = indirects.income[-1...][0]
    if income < min
      return (indirects[key][0] / min) * income
    else if income > max
      return (indirects[key][-1...][0] / max) * income
    else
      return interpolate_linear(zip(indirects.income, indirects[key]), income)

  res.total = 0

  for own key, val of indirects
    if key.indexOf('indirects_') == 0
      tax = Math.floor(getval(key))
      res[key[10...]] = tax
      res.total += tax

  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null
  opts.age = if query.age? then parseInt(query.age, 10) else null
  opts.indirects = if query.indirects? then true else null
  opts.blind = if query.blind? then true else null
  opts.documentation = if query.documentation? then true else null

  for k in ['allowances', 'income_tax', 'national_insurance']
    data[k] = uk_tax_data[k][opts.year] if uk_tax_data[k][opts.year]?

  calc.total = 0

  if opts.indirects
    data.indirects = uk_tax_data.indirects[opts.year] if uk_tax_data.indirects[opts.year]?

  if opts.income?
    if data.allowances?
      calc.allowances = calc_allowances(data.allowances, opts.income, opts)
      calc.taxable = Math.max(0, opts.income - calc.allowances.total)

    if data.income_tax? and calc.taxable?
      calc.income_tax = calc_income_tax(data.income_tax, calc.taxable)
      calc.total += calc.income_tax.total

    if data.national_insurance?
      calc.national_insurance = calc_national_insurance(data.national_insurance, opts.income, opts)
      calc.total += calc.national_insurance.total

    calc.directs = {total: calc.total}

    if opts.indirects
      calc.indirects = calc_indirects(data.indirects, opts.income)

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  if opts.documentation
    documentation.add_documentation(result)

  result
