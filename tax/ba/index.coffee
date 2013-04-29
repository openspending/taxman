taxman = require '../../taxman'

INCOME_TAX = 0.1
SOCIAL_CONTRIBUTIONS = 0.33
TAX_EXEMPTION_THRESHOLD = 25000
BRUTO=0.69

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null

  calc.direct = 100
  calc.indirect = 0
  calc.net_income = opts.income

  if opts.income > TAX_EXEMPTION_THRESHOLD
    totalTax = INCOME_TAX + SOCIAL_CONTRIBUTIONS
    calc.income_tax = opts.income * INCOME_TAX
    calc.social_contributions = opts.income * SOCIAL_CONTRIBUTIONS
    calc.direct = calc.income_tax + calc.social_contributions
    calc.net_income = opts.income - calc.direct

    # more rules: 
    # interest payments are discountable 
    # medical prescriptions

  # vat 17%
  # assumption: savings not large 
  # 16% of remaining income goes to VAT
  calc.indirect = calc.net_income * 0.16
  calc.net_income = calc.net_income - calc.indirect

  calc.total = calc.indirect + calc.direct

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
