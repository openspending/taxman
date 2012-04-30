# Data predominantly taken from tables at
#   http://www.hmrc.gov.uk/stats/tax_structure/menu.htm
#
# Other references include:
#   http://www.hmrc.gov.uk/rates/it.htm
#   http://www.hmrc.gov.uk/rates/nic.htm

exports.allowances =
  2000:
    personal: 4385

  2001:
    personal: 4535

  2002:
    personal: 4615

  2003:
    personal: 4615

  2004:
    personal: 4745

  2005:
    personal: 4895

  2006:
    personal: 5035

  2007:
    personal: 5225

  2008:
    personal: 6035

  2009:
    personal: 6475

  2010:
    personal: 6475
    personal_income_limit: 100000

  2011:
    personal: 7475
    personal_income_limit: 100000

  2012:
    personal: 8105
    personal_income_limit: 100000

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
