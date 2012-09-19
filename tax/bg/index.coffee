taxman = require '../../taxman'
bg_tax_data = require './data'

calc_tax = (it, taxable) ->
  res = {}
  [res.total, res.bands] = taxman.tax_in_bands(it.bands, taxable)
  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null

  for k in ['income_tax', 'social_security']
    data[k] = bg_tax_data[k][opts.year] if bg_tax_data[k][opts.year]?

  calc.total = 0

  if opts.income?
    calc.taxable = opts.income

    for k in ['income_tax', 'social_security']
      if data[k]? and calc.taxable?
        calc[k] = calc_tax(data[k], calc.taxable)
        calc.total += calc[k].total

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
