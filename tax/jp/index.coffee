jp_tax_data = require './data'

#
# TaxCalculator Base Class
#
class TaxCalculator
  constructor: (@opts, @data, @allowance_data) ->
  
  # Calculate a total tax amount（税額の計算）
  calc_tax: ->
    rate = @rate()
    income = @calc_income()
    taxable = @calc_taxable()
    income_allowances = @calc_income_allowances()
    tax_allowances = @calc_tax_allowances()
    tax = taxable * rate - tax_allowances
    tax = Math.floor(tax / 100) * 100
    
    return {
      total: tax
      income: income
      taxable: taxable
      rate: rate
      allowances:
        from_income: if taxable > 0 then income_allowances else 0
        from_tax: if taxable > 0 then tax_allowances else 0
    }
  
  # Calculate a total income amount （総所得金額の計算）
  calc_income: ->
    amount = 0
    amount += @_calc_interest_income()
    amount += @_calc_dividend_income()
    amount += @_calc_real_estate_income()
    amount += @_calc_business_income()
    amount += @_calc_employment_income()
    amount += @_calc_misc_income()
    amount += @_calc_occasional_income()
    amount += @_calc_capital_gain_income()
    return amount
  
  _calc_interest_income: -> 0     # 利子所得 (TODO)
  
  _calc_dividend_income: -> 0     # 配当所得 (TODO)
  
  _calc_real_estate_income: -> 0  # 不動産所得 (TODO)
  
  _calc_business_income: -> 0     # 事業所得 (TODO)
  
  _calc_employment_income: ->  0  # 給与所得
  
  _calc_misc_income: -> 0         # 雑所得 (TODO)
  
  _calc_occasional_income: -> 0   # 一時所得 (TODO)
  
  _calc_capital_gain_income: -> 0 # 譲渡所得 (TODO)
  
  # Calculate an amount deducted from income amount （所得控除額の計算）
  calc_income_allowances: ->
    amount = 0
    amount += @_calc_casualty_loss_allowance()
    amount += @_calc_medical_expense_allowance()
    amount += @_calc_social_insurance_premium_allowance()
    amount += @_calc_small_enterprise_mutual_aid_premium_allowance()
    amount += @_calc_life_insurance_premium_allowance()
    amount += @_calc_earthquake_insurance_premium_allowance()
    amount += @_calc_donation_allowance()
    amount += @_calc_disabled_allowance()
    amount += @_calc_widows_widowers_allowance()
    amount += @_calc_working_student_allowance()
    amount += @_calc_spouse_allowance()
    amount += @_calc_spouse_special_allowance()
    amount += @_calc_dependent_allowance()
    amount += @_calc_basic_allowance()
    return amount
  
  _calc_casualty_loss_allowance: -> 0                       # 雑損控除 (TODO)
  
  _calc_medical_expense_allowance: -> 0                     # 医療費控除 (TODO)
  
  _calc_social_insurance_premium_allowance: -> 0            # 社会保険料控除 (TODO)
  
  _calc_small_enterprise_mutual_aid_premium_allowance: -> 0 # 小規模企業共済等掛金控除 (TODO)
  
  _calc_life_insurance_premium_allowance: -> 0              # 生命保険料控除 (TODO)
  
  _calc_earthquake_insurance_premium_allowance: -> 0        # 地震保険料控除 (TODO)
  
  _calc_donation_allowance: -> 0                            # 寄附金控除 (TODO)
  
  _calc_disabled_allowance: -> 0                            # 障害者控除 (TODO)
  
  _calc_widows_widowers_allowance: -> 0                     # 寡婦（寡夫）控除 (TODO)
  
  _calc_working_student_allowance: -> 0                     # 勤労学生控除 (TODO)
  
  _calc_spouse_allowance: ->                                # 配偶者控除
    if @opts.spouse?
      return if @opts.spouse < 70 then @allowance_data.spouse else @allowance_data.spouse_elderly
    else
      return 0
  
  _calc_spouse_special_allowance: -> 0                      # 配偶者特別控除 (TODO)
  
  _calc_dependent_allowance: ->                             # 扶養控除
    amount = 0
    if @opts.dependents?
      allowance_data = @allowance_data
      @opts.dependents.forEach (age) ->
        if age < 16
          amount += allowance_data.dependent.young
        else if age <= 18
          amount += allowance_data.dependent.ordinary
        else if age <= 22
          amount += allowance_data.dependent.specific
        else if age <= 69
          amount += allowance_data.dependent.ordinary
        else if age >= 70
          amount += allowance_data.dependent.elderly
    return amount
  
  _calc_basic_allowance: ->                                 # 基礎控除
    @allowance_data.basic
  
  # Calculate a total taxable income （課税所得額の計算）
  calc_taxable: ->
    income = @calc_income()
    income_allowances = @calc_income_allowances()
    taxable = Math.floor((income - income_allowances) / 1000) * 1000
    if taxable > 0
      taxable
    else
      0
  
  # Calculate a tax rate （税率の計算）
  rate: -> 0
  
  # Calculate an amount deducted from tax amount （税額控除額の計算）(TODO)
  calc_tax_allowances: -> 0

#
# IncomeTaxCalculator Subclass
# 所得税（国税）の計算クラス
#
class IncomeTaxCalculator extends TaxCalculator
  calc_tax: ->
    calc = super
    taxable_allowances = @calc_taxable_allowances()
    calc.taxable_allowances = taxable_allowances
    calc.total -= taxable_allowances
    calc.formula = '(income - allowances.from_income) * rate - taxable_allowances - allowances.from_tax'
    return calc
  
  _get_rate_and_taxable_allowances: ->
    taxable = @calc_taxable()
    data = [0, 0]
    @data.rates.forEach (d) ->
      if taxable >= d.taxable.lower && taxable <= d.taxable.upper
        data = [d.rate, d.allowance]
    return data
    
  rate: ->
    @_get_rate_and_taxable_allowances()[0]
  
  # Calculate an amount deducted from taxable income amount（所得税の税率計算での控除額）
  calc_taxable_allowances: ->
    @_get_rate_and_taxable_allowances()[1]
  
  _calc_employment_income: ->
    income = 0
    if @opts.annual_salary <= 1800000
      income = @opts.annual_salary - @opts.annual_salary * 0.4
      if @opts.annual_salary * 0.4 < 650000
        income = @opts.annual_salary - 650000
    else if @opts.annual_salary <= 3600000
      income = @opts.annual_salary - @opts.annual_salary * 0.3 + 180000
    else if @opts.annual_salary <= 6600000
      income = @opts.annual_salary - @opts.annual_salary * 0.2 + 540000
    else if @opts.annual_salary <= 10000000
      income = @opts.annual_salary - @opts.annual_salary * 0.1 + 1200000
    else if @opts.annual_salary <= 15000000
      income = @opts.annual_salary - @opts.annual_salary * 0.05 + 1700000
    else
      income = @opts.annual_salary - 2450000
    
    return Math.floor(income)

#
# InhabitantTaxCalculator Subclass
# 住民税の計算クラス
#
class InhabitantTaxCalculator extends TaxCalculator
  # Calculate the taxation on per capita basis
  per_capita: -> 0 # 均等割の税額
  
  rate: -> @data.rate
  
  calc_tax: ->
    calc = super
    per_capita = @per_capita()
    calc.per_capita_tax = per_capita
    calc.income_tax = calc.total
    calc.total += per_capita
    calc.formula = 'per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)'
    return calc

  _calc_employment_income: ->
    income = 0
    if @opts.annual_salary < 651000
      income = 0
    else if @opts.annual_salary < 1619000
      income = @opts.annual_salary - 650000
    else if @opts.annual_salary < 1620000
      income = 969000
    else if @opts.annual_salary < 1622000
      income = 970000
    else if @opts.annual_salary < 1624000
      income = 972000
    else if @opts.annual_salary < 1628000
      income = 974000
    else if @opts.annual_salary < 1800000
      income = Math.floor(@opts.annual_salary / 4000) * 4000 * 0.6
    else if @opts.annual_salary < 3600000
      income = Math.floor(@opts.annual_salary / 4000) * 4000 * 0.7 - 180000
    else if @opts.annual_salary < 6600000
      income = Math.floor(@opts.annual_salary / 4000) * 4000 * 0.8 - 540000
    else if @opts.annual_salary < 10000000
      income = @opts.annual_salary * 0.9 - 1200000
    else
      income = @opts.annual_salary * 0.95 - 1700000
    
    return Math.floor(income)
  
#
# PrefecturalInhabitantTaxCalculator Subclass
# 住民税内の都道府県民税の計算クラス
#
class PrefecturalInhabitantTaxCalculator extends InhabitantTaxCalculator
  per_capita: ->
    per_capita_extra = if @opts.per_capita_extra? then @opts.per_capita_extra else 0
    return @data.per_capita + per_capita_extra

#
# MunicipalInhabitantTaxCalculator Subclass
# 住民税内の市町村民税の計算クラス
#
class MunicipalInhabitantTaxCalculator extends InhabitantTaxCalculator
  per_capita: -> @data.per_capita


exports.calculate = (params) ->
  opts = {}
  data = {}
  calc = {}
  
  # params.annual_salary is an alias for params.income
  if params.income?
    opts.annual_salary = parseInt(params.income, 10)
  else if params.annual_salary?
    opts.annual_salary = parseInt(params.annual_salary, 10)
  else
    opts.annual_salary = null
  
  opts.income = opts.annual_salary
  opts.year = if params.year? then parseInt(params.year, 10) else new Date().getFullYear()
  opts.tax_type = params.tax_type if params.tax_type?
  opts.spouse = parseInt(params.spouse, 10) if params.spouse?
  opts.per_capita_extra = parseInt(params.per_capita_extra, 10) if params.per_capita_extra?
  
  if params.dependents?
    type = Object.prototype.toString.call(params.dependents)
    if type is '[object Array]'
      opts.dependents = params.dependents
    else if type is '[object Number]'
      opts.dependents = [ params.dependents ]
  
  for k in ['income_tax', 'inhabitant_tax']
    if jp_tax_data[k][opts.year]?
      data[k] = jp_tax_data[k][opts.year]
    else
      data[k] = jp_tax_data[k]['latest']
  
  calc.total = 0
  
  if opts.annual_salary
    if !opts.tax_type or (opts.tax_type? and opts.tax_type is 'income_tax')
      calc.income_tax = new IncomeTaxCalculator(opts, data.income_tax, data.income_tax.allowances).calc_tax()
      calc.total += calc.income_tax.total
    if !opts.tax_type or (opts.tax_type? and opts.tax_type.match(/^inhabitant_tax/))
      calc.inhabitant_tax = if calc.inhabitant_tax? then calc.inhabitant_tax else {}
      if !opts.tax_type or (opts.tax_type? and opts.tax_type.match(/^inhabitant_tax(:prefectural)?$/))
        calc.inhabitant_tax.prefectural = new PrefecturalInhabitantTaxCalculator(opts, data.inhabitant_tax.prefectural, data.inhabitant_tax.allowances).calc_tax()
        calc.total += calc.inhabitant_tax.prefectural.total
      if !opts.tax_type or (opts.tax_type? and opts.tax_type.match(/^inhabitant_tax(:municipal)?$/))
        calc.inhabitant_tax.municipal = new MunicipalInhabitantTaxCalculator(opts, data.inhabitant_tax.municipal, data.inhabitant_tax.allowances).calc_tax()
        calc.total += calc.inhabitant_tax.municipal.total
  
  result =
    options: opts,
    data: data
  
  if Object.keys(calc).length != 0
    result.calculation = calc
  
  result
