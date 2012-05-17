taxman = require '../../taxman'
za_tax_data = require './data'

calc_income_tax = (it, taxable) ->
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(it.bands, taxable)
  return res

calc_rebates = (rebates, opts={}) ->
  res = {}
  res.base = rebates.base

  res.age_related = 0

  if opts.age?
    if opts.age >= 65
      res.age_related += rebates.aged_65_to_74
    if opts.age >= 75
      res.age_related += rebates.aged_75_plus

  res.total = res.base + res.age_related
  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null
  opts.age    = if query.age? then parseInt(query.age, 10) else null

  for k in ['income_tax', 'rebates']
    data[k] = za_tax_data[k][opts.year] if za_tax_data[k][opts.year]?

  calc.total = 0

  if opts.income?
    calc.taxable = opts.income

    if data.income_tax? and calc.taxable?
      calc.income_tax = calc_income_tax(data.income_tax, calc.taxable)
      calc.total += calc.income_tax.total

    if data.rebates?
      calc.rebates = calc_rebates(data.rebates, opts)
      calc.total -= calc.rebates.total

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
