express = require 'express'
app = express.createServer()

app.get '/', (req, res) ->
  res.send message: "Welcome to the TaxMan"

app.get '/:country', (req, res) ->
  try
    tax = require 'tax/' + req.params.country
  catch e
    res.send message: "no tax calculator for country '" + req.params.country + "'"

  res.send tax.calculate(req.query)

app.listen(3000)
