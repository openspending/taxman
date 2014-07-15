exports.income_tax =

  # Source: http://www.nts.go.kr/tax/tax_01.asp?cinfo_key=MINF5520100726112800&menu_a=100&menu_b=100&menu_c=400&flag=01
  2013:
    bands: [
      { width: 12000000.0, rate: 0.06 }
      { width: 46000000.0, rate: 0.15 }
      { width: 88000000.0, rate: 0.24 }
      { width: 300000000.0, rate: 0.35 }
      { rate: 0.38 }
    ]
