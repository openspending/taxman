# Since at least 2009, Bulgaria has charged a 10% flat rate tax on most kinds
# of income.
#
# Source: http://bbs.angloinfo.com/information/money/income-tax/general-income-tax

exports.income_tax =
  2012: bands: [{rate: 0.1}]
  2011: bands: [{rate: 0.1}]
  2010: bands: [{rate: 0.1}]
  2009: bands: [{rate: 0.1}]

# Social security contributions are codified in Bulgaria's "Кодекс за социално
# осигуряване" (Social Security Code). As of 2012, most employed citizens
# contribute 12.9% of their income to social security.
#
# Source: http://lex.bg/laws/ldoc/1597824512

exports.social_security =
  2012:
    bands: [{rate: 0.129}]
