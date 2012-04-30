fs = require 'fs'

# Data taken from
# http://www.hmrc.gov.uk/stats/tax_structure/menu.htm

DATA =
  allowances:
    2000:
      personal: 4385
      personal_income_limit: 17000

    2001:
      personal: 4535
      personal_income_limit: 17600

    2002:
      personal: 4615
      personal_income_limit: 17900

    2003:
      personal: 4615
      personal_income_limit: 18300

    2004:
      personal: 4745
      personal_income_limit: 18900

    2005:
      personal: 4895
      personal_income_limit: 19500

    2006:
      personal: 5035
      personal_income_limit: 20100

    2007:
      personal: 5225
      personal_income_limit: 20900

    2008:
      personal: 6035
      personal_income_limit: 21800

    2009:
      personal: 6475
      personal_income_limit: 22900

    2010:
      personal: 6475
      personal_income_limit: 22900

    2011:
      personal: 7475
      personal_income_limit: 24000

    2012:
      personal: 8105
      personal_income_limit: 25400

  income_tax:
    2000:
      bands: [
        {width: 1520, rate: 0.1}
        {width: 26880, rate: 0.22}
        {rate: 0.4}
      ]

    2001:
      bands: [
        {width: 1880, rate: 0.1}
        {width: 27520, rate: 0.22}
        {rate: 0.4}
      ]

    2002:
      bands: [
        {width: 1920, rate: 0.1}
        {width: 27980, rate: 0.22}
        {rate: 0.4}
      ]

    2003:
      bands: [
        {width: 1960, rate: 0.1}
        {width: 28540, rate: 0.22}
        {rate: 0.4}
      ]

    2004:
      bands: [
        {width: 2020, rate: 0.1}
        {width: 29380, rate: 0.22}
        {rate: 0.4}
      ]

    2005:
      bands: [
        {width: 2090, rate: 0.1}
        {width: 30310, rate: 0.22}
        {rate: 0.4}
      ]

    2006:
      bands: [
        {width: 2150, rate: 0.1}
        {width: 31150, rate: 0.22}
        {rate: 0.4}
      ]

    2007:
      bands: [
        {width: 2230, rate: 0.1}
        {width: 32370, rate: 0.22}
        {rate: 0.4}
      ]

    2008:
      bands: [
        {width: 34800, rate: 0.2}
        {rate: 0.4}
      ]

    2009:
      bands: [
        {width: 37300, rate: 0.2}
        {rate: 0.4}
      ]

    2010:
      bands: [
        {width: 37300, rate: 0.2}
        {width: 112600, rate: 0.4}
        {rate: 0.5}
      ]

    2011:
      bands: [
        {width: 35000, rate: 0.2}
        {width: 115000, rate: 0.4}
        {rate: 0.5}
      ]

    2012:
      bands: [
        {width: 34370, rate: 0.2}
        {width: 115630, rate: 0.4}
        {rate: 0.5}
      ]

  national_insurance:
    2000:
      pt: 76 * 52
      uel: 535 * 52
      mcr: 0.1
      acr: 0.0

    2001:
      pt: 87 * 52
      uel: 575 * 52
      mcr: 0.1
      acr: 0.0

    2002:
      pt: 89 * 52
      uel: 585 * 52
      mcr: 0.1
      acr: 0.0

    2003:
      pt: 89 * 52
      uel: 595 * 52
      mcr: 0.11
      acr: 0.01

    2004:
      pt: 91 * 52
      uel: 610 * 52
      mcr: 0.11
      acr: 0.01

    2005:
      pt: 94 * 52
      uel: 630 * 52
      mcr: 0.11
      acr: 0.01

    2006:
      pt: 97 * 52
      uel: 645 * 52
      mcr: 0.11
      acr: 0.01

    2007:
      pt: 100 * 52
      uel: 670 * 52
      mcr: 0.11
      acr: 0.01

    2008:
      pt: 105 * 52
      uel: 770 * 52
      mcr: 0.11
      acr: 0.01

    2009:
      pt: 110 * 52
      uel: 844 * 52
      mcr: 0.11
      acr: 0.01

    2010:
      pt: 110 * 52
      uel: 844 * 52
      mcr: 0.11
      acr: 0.01

    2011:
      pt: 139 * 52
      uel: 817 * 52
      mcr: 0.12
      acr: 0.02

    2012:
      pt: 146 * 52
      uel: 817 * 52
      mcr: 0.12
      acr: 0.02

personal_allowance = (allowances_info, gross_income) ->
  deduction = Math.max(0, gross_income - allowances_info.personal_income_limit) / 2
  deduction = Math.min(deduction, allowances_info.personal)
  deduction = Math.floor(deduction)
  allowances_info.personal - deduction

tax_payable = (band_info, taxable_income) ->
  tax_in_band = (band) ->
    Math.floor(band.rate * (Math.min(band.max, taxable_income) - Math.min(band.min, taxable_income)))

  total = 0
  bands = for band in band_info
    prev_total = total
    width = band.width ? Infinity
    total += width
    { width: width, rate: band.rate, min: prev_total, max: total }

  tax_by_band = bands.map tax_in_band

  [tax_by_band.reduce((a, b) -> a + b), tax_by_band]

ni_payable = (ni_info, taxable_income) ->
  band_info = [
    {width: ni_info.pt, rate: 0.0}
    {width: ni_info.uel - ni_info.pt, rate: ni_info.mcr}
    {rate: ni_info.mcr + ni_info.acr}
  ]

  tax_payable(band_info, taxable_income)

exports.calculate = (query) ->
  opts = {
    year: new Date().getFullYear()
  }
  data = {}
  calc = {}

  if query.year?
    opts.year = parseInt(query.year, 10)

  for k in ['allowances', 'income_tax', 'national_insurance']
    data[k] = DATA[k][opts.year] if DATA[k][opts.year]?

  if query.income?
    opts.income = parseInt(query.income, 10)

    if data.allowances?
      calc.allowances = {}
      calc.allowances.personal = personal_allowance(data.allowances, opts.income)
      calc.allowances.total = calc.allowances.personal
      calc.taxable = opts.income - calc.allowances.total

    if data.income_tax? and calc.taxable?
      calc.income_tax = {}
      [calc.income_tax.total, calc.income_tax.bands] = tax_payable(data.income_tax.bands, calc.taxable)

    if data.national_insurance? and calc.taxable?
      [calc.national_insurance, _] = ni_payable(data.national_insurance, calc.taxable)

  result =
    options: opts
    data: data

  if calc != {}
    result.calculation = calc

  result
