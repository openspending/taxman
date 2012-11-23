taxman = require '../../taxman'

exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.income = if query.income? then parseInt(query.income, 10) else null
  
  calc.total = 0    

  INCOME_TAX = 0.1
  SOCIAL_CONTRIBUTIONS = 0.33
  TAX_EXEMPTION_THRESHOLD = 25000
          
  if opts.income > TAX_EXEMPTION_THRESHOLD
    totalTax = INCOME_TAX + SOCIAL_CONTRIBUTIONS
    calc.total = opts.income * totalTax

    # more rules: 
    # interest payments are discountable 
    # medical prescriptions
          
    # vat 17%
    # assumption: savings not large 
    # 16% of remaining income goes to VAT
    calc.total += (opts.income * (1-totalTax)) * 0.16

  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
