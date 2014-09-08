matchreport = require "./matchreport"
express = require "express"
connect = require "connect"

app = () ->

  bower  = "#{__dirname}/../bower_components/"
  client = "#{__dirname}/../client/"

  @use "/static", require("express") .static(bower)
  @use            require("harp")    .mount(client)
  return this

app = express()

app.post("/match_report", connect.json(), matchreport.report)
app.get("/matches/:gameid", matchreport.get_matches)
app.get("/", (req, res) ->
	res.send "Something is working, but you probably mean to look at /matches/:gameid or send game to /match_report" 
)

app.listen(process.env.PORT)
