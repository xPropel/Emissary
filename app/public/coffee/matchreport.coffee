mdb = require "./mdb"
email = require "./email"

MDB_URL = process.env.MONGOHQ_URL || "mongodb://localhost/test"
MDB_COLL = process.env.MONGO_COLL || "games"

report = (req, res) ->
    console.log "Reporting a match..."
    if "gameId" of req.body
        console.log "Match id: " + req.body.gameId

        mdb.set MDB_URL, MDB_COLL, req.body

        recipients = req.body.tournamentMetaData.passbackDataPacket
        #email.send_email recipients, "match@report", "Match Report", "http://#{req.host}/#?matchId=#{req.body.gameId}"
        #email.send_email recipients, "match@report", "Match Report", "http://#{req.host}/matches/#{req.body.gameId}"
        email.send_email recipients, "match@report", "Match Report for Game #{req.params.gameId}", "This is the official result of your match: http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/#{req.params.gameId}"

    else
        console.log "No 'gameId' in req.body"

    res.send()

get_matches = (req, res) ->
    mdb.get MDB_URL, MDB_COLL, parseInt(req.params.gameId, 10), (err, doc) ->
        if err
            console.log "#{err} (gameId=#{req.params.gameId})"
            res.send "Error - Game #{req.params.gameId} doesn't exist."
        else
            res.send JSON.stringify doc


exports.report = report
exports.get_matches = get_matches
