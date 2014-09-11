matchreport    = require "./public/coffee/matchreport"
email          = require "./public/coffee/email"
express        = require "express"
bodyParser     = require "body-parser"
engine         = require "consolidate"


###
Kevin's code here
###


app = express()

app.use("/public", express.static("#{__dirname}/public"))


app.engine("html", engine.jade)
app.set("view engine", "html")
app.set("views", "#{__dirname}/views")

app.post("/report_match", bodyParser.json(), matchreport.report)

# Home -> Tournament Code Generator
app.get(["/", "/home", "/tournament_code"], (req, res) ->
	res.render "tournament_code/tournament.html"
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

# Serve files
app.get("/public/*", (req, res) ->
	res.sendFile(req.path)
)


app.listen(process.env.PORT)
