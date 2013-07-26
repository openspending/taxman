# TaxMan for Japan

This API calculates two types of taxes, *national income tax* (所得税) and *local inhabitant tax* (住民税).

## Basic call

    $ curl http://taxman.openspending.org/jp?annual_salary=4000000

## Parameters

#### annual_salary

Annual salary (年間給与収入).

#### year

Defaults to the current year.

#### tax_type

Filter the result. The following values can be specified.

* `income_tax` (所得税のみ)
* `inhabitant_tax` (住民税のみ)
* `inhabitant_tax:prefectural` (住民税のうち都道府県民税のみ)
* `inhabitant_tax:municipal` (住民税のうち市町村民税のみ)

If not specified, you get the total amount of all taxes.

#### spouse

Spouse age (配偶者の年齢).

#### dependents

Dependents ages (扶養親族の年齢).

## Result format

The result will contain three keys, `options`, `data` and `calculation`.

The `options` represents parsed options. The `data` is raw data used to perform the tax calculation. The `calculation` is the tax calculation and normally contains `total`, `income_tax` and `inhabitant_tax`.

```json
{
    "options": {
        "annual_salary": 4000000, 
        "dependents": [
            "17", 
            "13"
        ], 
        "spouse": 37, 
        "year": 2013
    },
    "data": { ... },
    "calculation": {
        "total": 333500, # 税額の総合計
        "income_tax": {
            "allowances": {
                "from_income": 1140000,  # 所得控除額
                "from_tax": 0            # 税額控除額
            }, 
            "formula": "(income - allowances.from_income) * rate - taxable_allowances - allowances.from_tax", 
            "income": 3740000,           # 所得額
            "rate": 0.1,                 # 税率
            "taxable": 2600000,          # 課税所得
            "taxable_allowances": 97500, # 所得税の税率計算での控除額
            "total": 162500              # 税額
        }, 
        "inhabitant_tax": {
            "prefectural": {
                "allowances": {
                    "from_income": 990000, 
                    "from_tax": 0
                }, 
                "formula": "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)", 
                "income": 2660000, 
                "income_tax": 66800,     # 所得割額
                "per_capita_tax": 1000,  # 均等割額
                "rate": 0.04, 
                "taxable": 1670000, 
                "total": 67800
            }, 
            "municipal": {
                "allowances": {
                    "from_income": 990000, 
                    "from_tax": 0
                }, 
                "formula": "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)", 
                "income": 2660000, 
                "income_tax": 100200, 
                "per_capita_tax": 3000,
                "rate": 0.06, 
                "taxable": 1670000, 
                "total": 103200
            }
        }
    }
}
```


## Examples

##### Case #1: Single, gained &yen;4,000,000 as a salary in 2012

    $ curl http://taxman.openspending.org/jp?annual_salary=4000000&year=2012

##### Case #2: Married, wife aged 37, two children aged 17 and 13

    $ curl http://taxman.openspending.org/jp?annual_salary=4000000&spouse=37&dependents=17&dependents=13

##### Case #3: Calculate a prefectural inhabitant tax only

    $ curl http://taxman.openspending.org/jp?annual_salary=4000000&tax_type=inhabitant_tax:municipal
    
Result:

```json
{
    "options": {
        "annual_salary": 4000000, 
        "tax_type": "inhabitant_tax:municipal", 
        "year": 2013
    },
    "data": { ... },
    "calculation": {
        "total": 142800,
        "inhabitant_tax": {
            "municipal": {
                "total": 142800,
                "allowances": {
                    "from_income": 330000, 
                    "from_tax": 0
                }, 
                "formula": "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)", 
                "income": 2660000, 
                "income_tax": 139800, 
                "per_capita_tax": 3000, 
                "rate": 0.06, 
                "taxable": 2330000
            }
        }
    }
}
```