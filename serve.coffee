fs            = require 'fs'
child_process = require 'child_process'
express       = require 'express'

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

app.get '/__about__', (req, res) ->
  version = ''

  git = child_process.spawn('git', ['describe', '--tags'])
  git.stdout.on 'data', (data) -> version += data

  git.on 'exit', (code) ->
    if code == 0
      res.json version: version.trim()
    else
      res.json message: "couldn't determine version", 418

port = process.env.PORT or 3000
app.listen port, ->
  console.log "Listening on port " + port

