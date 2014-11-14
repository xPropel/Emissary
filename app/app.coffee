process.stdout.write "Starting... "

express        = require "express"
bodyParser     = require "body-parser"
engine         = require "consolidate"
nib            = require "nib"
stylus         = require "stylus"
harp           = require "harp"

matchreport    = require "./public/js/match_report/matchreport"
email          = require "./public/js/match_report/email"


app = express()

# Configure Default Extension, Display Engine, and View Directory
app.set("views", "#{__dirname}/public")

# Set Up Public Directory
app.use express.static("#{__dirname}/public")

# Set Up Harp
app.use harp.mount("#{__dirname}/public"), (req, res, next) ->
  next()

# Set Up Match Reporting Endpoint (Riot Submits to Here)
app.post("/report_match", bodyParser.json(), matchreport.report)

# Home -> Tournament Code Generator
app.get(["/", "/index", "/candy", "/home", "/tournament_code", "/tournamentcode"], (req, res, next) ->
    res.render "tournament.jade"
    next()
)

# Raw JSON Output of Match
app.get("/raw/:gameId", matchreport.get_matches)

# Match Information
app.get("/match/:gameId", (req, res, next) ->
    res.redirect "http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/#{req.params.gameId}"
    #res.render("../match_report/report2.html")
    next()
)

app.get("/mastery", (req, res, next) ->
    res.render "mastery.jade"
    next()
)

app.get("/test", (req, res, next) ->
    res.render "test.jade"
    next()
)

###
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
###

app.listen(process.env.PORT | 3000)

console.log "Started!"