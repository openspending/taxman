fs = require 'fs'
express = require 'express'

app = express.createServer(express.logger())

app.enable 'jsonp callback'

app.get '/', (req, res) ->
  fs.readdir './tax', (err, files) ->
    throw (err) if err

    jurisdictions = {}

    files.forEach (name) ->
      jurisdictions[name] = (process.env.HEROKU_URL or '') + '/' + name

    res.json
      message: "Welcome to the TaxMan"
      jurisdictions: jurisdictions

app.get /\/([a-z][a-z])$/, (req, res) ->
  country = req.params[0]
  try
    tax = require './tax/' + country
    res.json tax.calculate(req.query)
  catch e
    res.json message: "no tax calculator for country '" + country + "'", 404

port = process.env.PORT or 3000
app.listen port, ->
  console.log "Listening on port " + port

