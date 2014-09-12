matchreport    = require "./public/coffee/matchreport"
email          = require "./public/coffee/email"
express        = require "express"
bodyParser     = require "body-parser"
engine         = require "consolidate"


app = () ->

  bower  = "#{__dirname}/../bower_components/"
  client = "#{__dirname}/../client/"

  @use "/static", require("express") .static(bower)
  @use            require("harp")    .mount(client)
  return this


app = express()

# Set Up Public Directory
app.use("/public", express.static("#{__dirname}/public"))

# Configure Default Extension, Display Engine, and View Dir.
app.engine("html", engine.jade)
app.set("view engine", "html")
app.set("views", "#{__dirname}/views")

# Set Up Match Reporting Endpoint (Riot Submits to Here)
app.post("/report_match", bodyParser.json(), matchreport.report)

# Home -> Tournament Code Generator
app.get(["/", "/index", "/candy", "/home", "/tournament_code"], (req, res) ->
    res.render "tournament_code/tournament.html"
)

# Raw JSON Output of Match
app.get("/raw/:gameId", matchreport.get_matches)

# Match Information
app.get("/match/:gameId", (req, res) ->
    res.redirect "http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/#{req.params.gameId}"
    #res.render("../match_report/report2.html")
)

# Test Sending Email
app.get("/testemail/:email", (req, res) ->
    res.send "Sending email to #{req.params.email}"
    attachments = [{
            filename: "filename.json",
            content: "why doesn't this work"
            contentType: "text/plain"
        }]
    email.send_email "#{req.params.email}", "test@email", "☆*:.｡. o(≧▽≦)o .｡.:*☆", "∠( ᐛ 」∠)＿\nヾ(@°▽°@)ノ", attachments
)

# Serve Files Directly
app.get("/public/*", (req, res) ->
    res.sendFile(req.path)
)


app.listen(process.env.PORT)
