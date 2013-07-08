taxman = require '../../taxman'
ba_tax_data = require './data'

calc_brutto = (netto, data) ->
  # All contributions are by employee (not employer)
  # Tax is calculated with:
  # tax = brutto - (contributions * brutto) - tax_exemption)*income_tax
  # Netto salary is computed as
  # netto = brutto - (contributions * brutto) - tax
  # Using algebra we get
  # brutto = (netto - exemption*income tax)/(1-contributions)*(1-income_tax)
  sum = (val.employee ?= 0 for key,val of data.contributions).reduce (x,y) -> 
    x + y

  return (netto - data.salary_exemption*data.income_tax)/((1-sum)*(1-data.income_tax))

calc_contributions = (income, data) ->
  res = { }

  for key,val of data.contributions
    res[key] = 
      breakdown:
        employee: (val.employee ?= 0) * income
        employer: (val.employer ?= 0) * income
    res[key].total = res[key].breakdown.employee + res[key].breakdown.employer

    res.total = (res.total ?= 0) + res[key].total
    res.breakdown =
      employee: ((res.breakdown ?= {}).employee ?= 0) \
                  + res[key].breakdown.employee
      employer: ((res.breakdown ?= {}).employer ?= 0) \
                  + res[key].breakdown.employer

  return res

calc_income_tax = (taxable, data) ->
  return taxable * data.income_tax

calc_total_deduction = (deductions) ->
  return (val for key,val of deductions).reduce (x,y) -> x+y

calc_indirects = (netto_income, data) ->
  res = {}
  for key,val of data.indirects
    res[key] = netto_income * val
    res.total = (res.total ?= 0) + res[key]

  return res

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year = if query.year? then parseInt(query.year, 10) else 2012
  opts.net_income = if query.net_income? then parseInt(query.net_income, 10) else null
  opts.income = if query.income? then parseInt(query.income, 10) else null
  opts.entity = if query.entity? then query.entity else null

  # more rules: 
  # interest payments are discountable 
  # medical prescriptions

  data[opts.entity] = ba_tax_data[opts.entity]
  calc.income = if opts.income? then opts.income else calc_brutto(opts.net_income, data[opts.entity])
  calc.contributions = calc_contributions(calc.income, data[opts.entity])
  calc.deductions = 
    employee: ((calc.contributions.breakdown ?= {}).employee ?= 0),
    salary: (data[opts.entity].salary_exemption ?= 0)
  calc.deductions.total = calc_total_deduction(calc.deductions)
  calc.taxable = calc.income - calc.deductions.total
  calc.income_tax = calc_income_tax(calc.taxable, data[opts.entity])
  calc.net_income = calc.income - calc.deductions.employee - calc.income_tax
  calc.indirects = calc_indirects(calc.net_income, data[opts.entity])
  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
