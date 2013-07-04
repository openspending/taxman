taxman = require '../../taxman'

# by Kenan, July 2013 - kenanz@gmail.com
# input: income is net_income
# calculation for 3 levels: Federation (fed), RS (rs) and District of Brcko (brcko)

# Fed.
BRUTO1_PENSIONS = 24.638
BRUTO1_HEALTH= 18.116
BRUTO1_UNEMPLOYMENT= 2.174
BRUTO2_PENSIONS = 6.00
BRUTO2_HEALTH= 4.00
BRUTO2_UNEMPLOYMENT= 0.5
EXEMPTION_AMOUNT = 300 # this is KM, not a percentage 
OTHER = 0.01
WATER = 0.005
DISASTER = 0.005
VAT = 0.17
EXEMPTION = 0
BRUTO1_TEMP= 0
INCOME_BRUTO= 0

# RS
RS_TOTAL_PERCENTAGE= 1.65837
RS_PENSIONS= 30.68
RS_HEALTH= 19.90
RS_UNEMPLOYMENT= 1.658
RS_CHILDPROTECT= 2.488

# Brcko
BRCKO_TOTAL_PERCENTAGE= 1.5848
BRCKO_PENSIONS= 28.526
BRCKO_HEALTH= 19.81
BRCKO_UNEMPLOYMENT= 2.377

calc_contributions = (contributions, income, opts={}) ->
  res = {}
  res.pension= opts.net_income * BRUTO1_PENSIONS /100
  res.health= opts.net_income * BRUTO1_HEALTH /100
  res.unemployment= opts.net_income * BRUTO1_UNEMPLOYMENT /100
  BRUTO1_TEMP= opts.net_income + res.pension + res.health + res.unemployment
  
  res.pension= res.pension + BRUTO1_TEMP * BRUTO2_PENSIONS /100
  res.health= res.health + BRUTO1_TEMP * BRUTO2_HEALTH /100
  res.unemployment= res.unemployment + BRUTO1_TEMP * BRUTO2_UNEMPLOYMENT /100
  res.water = opts.net_income * WATER
  res.disaster = opts.net_income * DISASTER
  
  res.total= res.pension + res.health + res.unemployment + res.water + res.disaster
  INCOME_BRUTO= res.total
  
  return res
  

calc_contributions_rs = (contributions, income, opts={}) ->
  res = {}
  res.pension= opts.net_income * RS_PENSIONS /100
  res.health= opts.net_income * RS_HEALTH /100
  res.unemployment= opts.net_income * RS_UNEMPLOYMENT /100
  res.childprotect= opts.net_income * RS_CHILDPROTECT /100
  res.total= res.pension + res.health + res.unemployment + res.childprotect  
  BRUTO1_TEMP= res.total
  
  return res
  
calc_contributions_brcko = (contributions, income, opts={}) ->
  res = {}
  res.pension= opts.net_income * BRCKO_PENSIONS /100
  res.health= opts.net_income * BRCKO_HEALTH /100
  res.unemployment= opts.net_income * BRCKO_UNEMPLOYMENT /100
  res.total= res.pension + res.health + res.unemployment 
  BRUTO1_TEMP= res.total
  
  return res  
  
exports.calculate = (query) ->
  opts = {}
  data = {}
  calc = {}

  opts.year   = if query.year? then parseInt(query.year, 10) else 2012
  opts.net_income = if query.net_income? then parseInt(query.net_income, 10) else null
  opts.entity = if query.entity? then query.entity else null

  # more rules: 
  # interest payments are discountable 
  # medical prescriptions

  if opts.entity == 'fed'
    EXEMPTION = opts.net_income - EXEMPTION_AMOUNT
    calc.income_tax= EXEMPTION * 0.1
    calc.vat= opts.net_income * VAT
    calc.contributions = calc_contributions(data.contributions, opts.net_income, opts)
    calc.income= INCOME_BRUTO + calc.income_tax + opts.net_income

	
  if opts.entity == 'rs'
    calc.vat= opts.net_income * VAT
    calc.contributions = calc_contributions_rs(data.contributions, opts.net_income, opts)
    calc.income_tax= ((opts.net_income * RS_TOTAL_PERCENTAGE ) - BRUTO1_TEMP)* 0.1
    calc.income= opts.net_income * RS_TOTAL_PERCENTAGE 

  if opts.entity == 'brcko'
    calc.vat= opts.net_income * VAT
    calc.contributions = calc_contributions_brcko(data.contributions, opts.net_income, opts)
    calc.income_tax= ((opts.net_income * BRCKO_TOTAL_PERCENTAGE ) - BRUTO1_TEMP  - EXEMPTION_AMOUNT)* 0.1
    calc.income= opts.net_income * BRCKO_TOTAL_PERCENTAGE 
	
  result =
    options: opts
    data: data

  if Object.keys(calc).length != 0
    result.calculation = calc

  result
