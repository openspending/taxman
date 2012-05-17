# Data sourced by Cobus Coetzee. Available on thedatahub at:
#   http://thedatahub.org/dataset/south-african-national-gov-budget-2012-13

exports.income_tax =
  2012:
    bands: [
      {width: 160000, rate: 0.18}
      {width: 90000,  rate: 0.25}
      {width: 96000,  rate: 0.30}
      {width: 138000, rate: 0.35}
      {width: 133000, rate: 0.38}
      {rate: 0.4}
    ]

exports.rebates =
  2012:
    base: 11440
    # these are ADDITIONAL rebates on top of the base value
    aged_65_to_74: 6390
    aged_75_plus: 2130
