matchreport = require "./matchreport"
email = require "./email"
express = require "express"
connect = require "connect"
bodyParser = require "body-parser"
cons = require "consolidate"

app = () ->

  bower  = "#{__dirname}/../bower_components/"
  client = "#{__dirname}/../client/"

  @use "/static", require("express") .static(bower)
  @use            require("harp")    .mount(client)
  return this


app = express()

app.engine("html", require("jade").__express)
app.set("view engine", "html")

app.post("/report_match", bodyParser.json(), matchreport.report)

# Home -> Tournament Code Generator
app.get("/", (req, res) ->
	res.render "../tournament_code/index"
)

# Raw JSON output of match
app.get("/raw/:gameId", matchreport.get_matches)

# Match information
app.get("/match/:gameId", (req, res) ->
	res.redirect "http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/#{req.params.gameId}"
	#res.render("../match_report/report2.html")
)

# Test sending email
app.get("/testemail/:email", (req, res) ->
	res.send "sending email to " + req.params.email
	email.send_email "#{req.params.email}", "aqueous-ocean-9313@aqueous-ocean-9313", "☆*:.｡. o(≧▽≦)o .｡.:*☆", "∠( ᐛ 」∠)＿\nヾ(@°▽°@)ノ"
)

app.listen(process.env.PORT)
