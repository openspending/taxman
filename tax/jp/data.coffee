exports.income_tax =
  latest:
    rates: [
      { taxable: { lower: 0,       upper: 1950000 },  rate: 0.05, allowance: 0 }
      { taxable: { lower: 1950001, upper: 3300000 },  rate: 0.1,  allowance: 97500 }
      { taxable: { lower: 3300001, upper: 6950000 },  rate: 0.2,  allowance: 427500 }
      { taxable: { lower: 6950001, upper: 9000000 },  rate: 0.23, allowance: 636000 }
      { taxable: { lower: 9000001, upper: 18000000 }, rate: 0.33, allowance: 1536000 }
      { taxable: { lower: 18000001 },                 rate: 0.4,  allowance: 2796000 }
    ]
    allowances:
      basic: 380000
      spouse: 380000
      spouse_elderly: 480000
      dependent:
        young: 0
        ordinary: 380000
        specific: 630000
        elderly: 480000
        elderly_parent: 580000

exports.inhabitant_tax =
  latest:
    prefectural:
      per_capita: 1000
      rate: 0.04
    municipal:
      per_capita: 3000
      rate: 0.06
    allowances:
      basic: 330000
      spouse: 330000
      spouse_elderly: 380000
      dependent:
        young: 0,                # 年少扶養（16歳未満の扶養親族）
        ordinary: 330000,        # 一般扶養控除（16歳以上19歳未満、23歳以上70歳未満の扶養親族）
        specific: 450000,        # 特定扶養控除（19歳以上23歳未満の扶養親族）
        elderly: 380000,         # 老人扶養控除（70歳以上の扶養親族）
        elderly_parent: 450000,  # 老人扶養親族のうち、納税義務者または配偶者の（祖）父母等で同居の扶養親族
