should = require 'should'
tax = require '../index'

# Example of calculation of Inhabitant tax
#   http://www.city.osaka.lg.jp/contents/wdu020/zaisei/english/guide/example_eng.pdf

suite 'Options', ->
  test 'no params', ->
    res = tax.calculate {}
    res.options.should.eql {
      year: new Date().getFullYear()
      annual_salary: null
    }
    
    res.calculation.should.eql {
      total: 0
    }
  
  test 'specify params', ->
    res = tax.calculate {
      year: 2012
      annual_salary: 2000000
      tax_type: 'income_tax'
    }
    res.options.year.should.eql 2012
    res.options.annual_salary.should.eql 2000000
    res.options.tax_type.should.eql 'income_tax'

suite 'Tax Calculation', ->
  
  test 'No allowance', ->
    res = tax.calculate {
      year: 2013
      annual_salary: 4436629
    }
    
    res.calculation.should.eql {
      total: 314300 + 4000 + 107100 + 160600
      income_tax: {
        total: 314300
        income: 4089303
        taxable: 3709000
        rate: 0.2
        allowances:
          from_income: 380000
          from_tax: 0
        taxable_allowances: 427500
        formula: "(income - allowances.from_income) * rate - taxable_allowances - allowances.from_tax"
      },
      inhabitant_tax:
        prefectural:
          total: 1000 + 107100
          income: 3008800
          taxable: 2678000
          rate: 0.04
          allowances:
            from_income: 330000
            from_tax: 0
          per_capita_tax: 1000
          income_tax: 107100
          formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
        municipal:
          total: 3000 + 160600
          income: 3008800
          taxable: 2678000
          rate: 0.06
          allowances:
            from_income: 330000
            from_tax: 0
          per_capita_tax: 3000
          income_tax: 160600
          formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
    }
  
  suite 'Narrow a result', ->
    test 'Only income tax', ->
      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        tax_type:'income_tax'
      }
      
      res.calculation.should.eql {
        total: 314300
        income_tax: {
          total: 314300
          income: 4089303
          taxable: 3709000
          rate: 0.2
          allowances:
            from_income: 380000
            from_tax: 0
          taxable_allowances: 427500
          formula: "(income - allowances.from_income) * rate - taxable_allowances - allowances.from_tax"
        }
      }
    
    test 'Only inhabitant_tax', ->
      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        tax_type:'inhabitant_tax'
      }
      
      res.calculation.should.eql {
        total: 4000 + 107100 + 160600
        inhabitant_tax:
          prefectural:
            total: 1000 + 107100
            income: 3008800
            taxable: 2678000
            rate: 0.04
            allowances:
              from_income: 330000
              from_tax: 0
            per_capita_tax: 1000
            income_tax: 107100
            formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
          municipal:
            total: 3000 + 160600
            income: 3008800
            taxable: 2678000
            rate: 0.06
            allowances:
              from_income: 330000
              from_tax: 0
            per_capita_tax: 3000
            income_tax: 160600
            formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
      }
      
    test 'Only inhabitant_tax:prefectural', ->
      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        tax_type:'inhabitant_tax:prefectural'
      }
      
      res.calculation.should.eql {
        total: 1000 + 107100
        inhabitant_tax:
          prefectural:
            total: 1000 + 107100
            income: 3008800
            taxable: 2678000
            rate: 0.04
            allowances:
              from_income: 330000
              from_tax: 0
            per_capita_tax: 1000
            income_tax: 107100
            formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
      }
      
    test 'Only inhabitant_tax:municipal', ->
      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        tax_type:'inhabitant_tax:municipal'
      }
      
      res.calculation.should.eql {
        total: 3000 + 160600
        inhabitant_tax:
          municipal:
            total: 3000 + 160600
            income: 3008800
            taxable: 2678000
            rate: 0.06
            allowances:
              from_income: 330000
              from_tax: 0
            per_capita_tax: 3000
            income_tax: 160600
            formula: "per_capita_tax + ((income - allowances.from_income) * rate - allowances.from_tax)"
      }
      
  
  suite 'per_capita_extra', ->
    res = tax.calculate {
      year: 2013
      annual_salary: 2000000
    }
    
    res2 = tax.calculate {
      year: 2013
      annual_salary: 2000000
      per_capita_extra: 1200
    }
    test 'total', ->
      res2.calculation.total.should.eql res.calculation.total + 1200
    test 'inhabitant_tax.prefectural.total', ->
      res2.calculation.inhabitant_tax.prefectural.total.should.eql res.calculation.inhabitant_tax.prefectural.total + 1200
    test 'inhabitant_tax.prefectural.per_capita', ->
      res2.calculation.inhabitant_tax.prefectural.per_capita_tax.should.eql res.calculation.inhabitant_tax.prefectural.per_capita_tax + 1200
  
  suite 'Allowances from income', ->
    test 'Deduction for spouses', ->
      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        spouse: 39
      }
      res.calculation.income_tax.allowances.from_income.should.eql 380000 + 380000
      res.calculation.inhabitant_tax.prefectural.allowances.from_income.should.eql 330000 + 330000
      res.calculation.inhabitant_tax.municipal.allowances.from_income.should.eql 330000 + 330000

      res = tax.calculate {
        year: 2013
        annual_salary: 4436629
        spouse: 70
      }
      res.calculation.income_tax.allowances.from_income.should.eql 380000 + 480000
      res.calculation.inhabitant_tax.prefectural.allowances.from_income.should.eql 330000 + 380000
      res.calculation.inhabitant_tax.municipal.allowances.from_income.should.eql 330000 + 380000
      
    suite 'Desuction for dependents', ->
      test 'one dependent', ->
        res = tax.calculate {
          year: 2013
          annual_salary: 4436629
          dependents: 23
        }
        res.calculation.inhabitant_tax.prefectural.allowances.from_income.should.eql 330000 + 330000
        res.calculation.inhabitant_tax.municipal.allowances.from_income.should.eql 330000 + 330000
      
      test 'some dependents', ->
        res = tax.calculate {
          year: 2013
          annual_salary: 4436629
          dependents: [13, 17, 20, 23, 70]
        }
        
        res.calculation.income_tax.allowances.from_income.should.eql 380000 + 380000 * 2 + 630000 + 480000
        res.calculation.inhabitant_tax.prefectural.allowances.from_income.should.eql 330000 + 330000 * 2 + 450000 + 380000
        res.calculation.inhabitant_tax.municipal.allowances.from_income.should.eql 330000 + 330000 * 2 + 450000 + 380000
      
