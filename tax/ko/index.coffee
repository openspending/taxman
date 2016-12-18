taxman = require '../../taxman'
mx_tax_data = require './data'

calc_tax = (it, taxable) ->
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(it.bands, taxable)
  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else 2013
  opts.income = if query.income? then parseInt(query.income, 10) else null

  data.income_tax = mx_tax_data.income_tax[opts.year] if mx_tax_data.income_tax[opts.year]?

  calc.total = 0

  if opts.income?
    calc.taxable = opts.income

    if data.income_tax? and calc.taxable?
      calc.income_tax = calc_tax(data.income_tax, calc.taxable)
      calc.total += calc.income_tax.total

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
