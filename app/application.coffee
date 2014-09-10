matchreport = require "./matchreport"
express = require "express"
connect = require "connect"
bodyParser = require "body-parser"

app = () ->

  bower  = "#{__dirname}/../bower_components/"
  client = "#{__dirname}/../client/"

  @use "/static", require("express") .static(bower)
  @use            require("harp")    .mount(client)
  return this

app = express()

app.post("/match_report", bodyParser.json(), matchreport.report)

app.get("/matches/:gameId", matchreport.get_matches)
app.get("/", (req, res) ->
	res.send "Something is working, but you probably mean to look at /matches/:gameid or send game to /match_report" 
)
app.get("/testemail/:email", (req, res) ->
	res.send "sending email to " + req.params.email
	email = require "./email"
	email.send_email "#{req.params.email}", "aqueous-ocean-9313@aqueous-ocean-9313", "/testemail/:email", "i should get this email"
)

app.listen(process.env.PORT)
