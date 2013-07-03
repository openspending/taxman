taxman = require '../../taxman'

# input: income is net_income
# calculation for Federation - entity parametar is not yet implemented

BRUTO1_PENSIONS = 24.638
BRUTO1_HEALTH= 18.116
BRUTO1_UNEMPLOYMENT= 2.174
BRUTO2_PENSIONS = 6.00
BRUTO2_HEALTH= 4.00
BRUTO2_UNEMPLOYMENT= 0.5
EXEMPTION_BASE = 0.3
OTHER = 0.01
WATER = 0.005
DISASTER = 0.005
VAT = 0.17
EXEMPTION = 0
BRUTO1_TEMP= 0

calc_contributions = (contributions, income, opts={}) ->
  res = {}
  res.pension= opts.income * BRUTO1_PENSIONS /100
  res.health= opts.income * BRUTO1_HEALTH /100
  res.unemployment= opts.income * BRUTO1_UNEMPLOYMENT /100
  BRUTO1_TEMP= opts.income + res.pension + res.health + res.unemployment
  
  res.pension= res.pension + BRUTO1_TEMP * BRUTO2_PENSIONS /100
  res.health= res.health + BRUTO1_TEMP * BRUTO2_HEALTH /100
  res.unemployment= res.unemployment + BRUTO1_TEMP * BRUTO2_UNEMPLOYMENT /100
  res.water = opts.income * WATER
  res.disaster = opts.income * DISASTER
  
  res.total= res.pension + res.health + res.unemployment + res.water + res.disaster
  
  return res
  
  
exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  #opts.year   = if query.year? then parseInt(query.year, 10) else new Date().getFullYear()
  opts.year   = if query.year? then parseInt(query.year, 10) else 2012
  opts.income = if query.income? then parseInt(query.income, 10) else null

  #calc.direct = 100
  #calc.indirect = 0
  calc.net_income = opts.income


  #if opts.income > TAX_EXEMPTION_THRESHOLD
  #  totalTax = INCOME_TAX + SOCIAL_CONTRIBUTIONS
  #  calc.income_tax = opts.income * INCOME_TAX
  #  calc.social_contributions = opts.income * SOCIAL_CONTRIBUTIONS
  #  calc.direct = calc.income_tax + calc.social_contributions
  #  calc.net_income = opts.income - calc.direct

    # more rules: 
    # interest payments are discountable 
    # medical prescriptions


  #if opts.entity=='fed'
  #calc.tax= calc.net_income * BRUTO1/100
  #calc.tax= ((calc.net_income + calc.tax) * BRUTO2)/100 + calc.tax
  EXEMPTION = opts.income - (opts.income * EXEMPTION_BASE)
  calc.income_tax= EXEMPTION * 0.1
  #calc.income_tax= calc.income_tax + (calc.net_income * OTHER)  #Kenan: I've inluded OTHER in income_tax, not sure if it's sort of contribution?
  calc.vat= opts.income * VAT
  

  
  calc.contributions = calc_contributions(data.contributions, opts.income, opts)
  
  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
