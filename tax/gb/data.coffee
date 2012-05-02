# Data predominantly taken from tables at
#   http://www.hmrc.gov.uk/stats/tax_structure/menu.htm
#
# Other references include:
#   http://www.hmrc.gov.uk/rates/it.htm
#   http://www.hmrc.gov.uk/rates/nic.htm
#
# See the DataHub package `uk-tax-calculator`
#   http://thedatahub.org/dataset/uk-tax-calculator

exports.allowances =
  2000:
    personal: 4385
    blind: 1400
    aged_65_to_74: 1405
    aged_75_plus: 1665
    aged_income_limit: 17000

  2001:
    personal: 4535
    blind: 1450
    aged_65_to_74: 1455
    aged_75_plus: 1725
    aged_income_limit: 17600

  2002:
    personal: 4615
    blind: 1480
    aged_65_to_74: 1485
    aged_75_plus: 1755
    aged_income_limit: 17900

  2003:
    personal: 4615
    blind: 1510
    aged_65_to_74: 1995
    aged_75_plus: 2105
    aged_income_limit: 18300

  2004:
    personal: 4745
    blind: 1560
    aged_65_to_74: 2085
    aged_75_plus: 2205
    aged_income_limit: 18900

  2005:
    personal: 4895
    blind: 1610
    aged_65_to_74: 2195
    aged_75_plus: 2325
    aged_income_limit: 19500

  2006:
    personal: 5035
    blind: 1660
    aged_65_to_74: 2245
    aged_75_plus: 2385
    aged_income_limit: 20100

  2007:
    personal: 5225
    blind: 1730
    aged_65_to_74: 2325
    aged_75_plus: 2465
    aged_income_limit: 20900

  2008:
    personal: 6035
    blind: 1800
    aged_65_to_74: 2995
    aged_75_plus: 3145
    aged_income_limit: 21800

  2009:
    personal: 6475
    blind: 1890
    aged_65_to_74: 3015
    aged_75_plus: 3165
    aged_income_limit: 22900

  2010:
    personal: 6475
    personal_income_limit: 100000
    blind: 1890
    aged_65_to_74: 3015
    aged_75_plus: 3165
    aged_income_limit: 22900

  2011:
    personal: 7475
    personal_income_limit: 100000
    blind: 1980
    aged_65_to_74: 2465
    aged_75_plus: 2615
    aged_income_limit: 24000

  2012:
    personal: 8105
    personal_income_limit: 100000
    blind: 2100
    aged_65_to_74: 2395
    aged_75_plus: 2555
    aged_income_limit: 25400

exports.income_tax =
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

exports.national_insurance =
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

# income: average gross income per decile (including benefits, pensions etc.)
# directs: average direct taxation (income tax, employee NI and council tax)
# indirects_vat: average total VAT paid
# indirects_tobacco: average total tobacco tax paid
# indirects_alcohol: average total alcohol tax paid (beer, cider, wine, and spirits)
# indirects_motoring: average total car-related costs (petrol & car tax)
# indirects_remainder: average total indirect taxation excluding VAT, tobacco, alcohol, and car costs

exports.indirects =
  # 2008 data from the now broken link:
  #   http://www.statistics.gov.uk/CCI/article.asp?ID=2440
  # Now available at:
  #   http://www.ons.gov.uk/ons/rel/household-income/the-effects-of-taxes-and-benefits-on-household-income/2008-09/index.html
  2008:
    income: [9219, 13583, 17204, 22040, 25190, 32995, 37592, 46268, 56889, 94341]
    directs: [1172, 1368, 1939, 3108, 3973, 6118, 7423, 10172, 13463, 23047]
    indirects_vat: [1101, 1085, 1295, 1562, 1609, 1927, 2155, 2616, 2871, 3747]
    indirects_tobacco: [288, 310, 317, 320, 295, 341, 286, 311, 235, 251]
    indirects_alcohol: [150, 167, 182, 243, 222, 261, 306, 392, 450, 526]
    indirects_motoring: [349, 289, 373, 505, 519, 632, 727, 851, 909, 949]
    indirects_remainder: [1016, 969, 1125, 1262, 1319, 1507, 1630, 1884, 2148, 2622]

  # 2009 data from:
  #   http://www.ons.gov.uk/ons/rel/household-income/the-effects-of-taxes-and-benefits-on-household-income/2009-2010/index.html
  2009:
    income: [9275, 14184, 17375, 20890, 26435, 32019, 37515, 46257, 57969, 101808]
    directs: [1113, 1277, 1788, 2612, 4155, 5545, 7386, 9421, 13281, 25719]
    indirects_vat: [995, 1050, 1188, 1315, 1506, 1839, 2015, 2190, 2583, 3745]
    indirects_tobacco: [280, 361, 323, 382, 330, 372, 376, 274, 227, 185]
    indirects_alcohol: [77+98, 69+89, 77+99, 85+144, 108+134, 150+186, 149+198, 161+215, 194+312, 163+386]
    indirects_motoring: [285+89, 257+81, 306+96, 330+107, 428+139, 517+155, 526+170, 670+200, 716+213, 726+234]
    indirects_remainder: [1082, 1117, 1205, 1275, 1443, 1611, 1714, 1913, 2196, 3003]
