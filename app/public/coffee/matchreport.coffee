mdb = require "./mdb"
email = require "./email"

MDB_URL = process.env.MONGOHQ_URL
MDB_COLL = process.env.MONGO_COLL || "games"

MG_FROM = process.env.MAILGUN_SMTP_LOGIN

report = (req, res) ->
    if "gameId" of req.body
        console.log "Recording Match #{req.body.gameId}"
        mdb.set MDB_URL, MDB_COLL, req.body

        recipients = req.body.tournamentMetaData.passbackDataPacket
        attachments = [{
            filename: "game#{req.body.gameId}.json"
            path: "#{APP_URL}/raw/#{req.body.gameId}"
            contentType: "application/json"
          }]
        # Sender Email is Completely Made Up
        email.send_email recipients, "Emissary <#{MG_FROM}>", "Emissary • Match Report for Game #{req.body.gameId}", "This is the official result of your match: http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/#{req.body.gameId}", attachments
    else
        console.log "Failed to record match - No 'gameId' in req.body"
        res.status(400).send "No 'gameId' in req.body"

get_matches = (req, res) ->
    mdb.get MDB_URL, MDB_COLL, parseInt(req.params.gameId, 10), (err, doc) ->
        if err
            console.log "#{err} (gameId=#{req.params.gameId})"
            res.send "Game #{req.params.gameId} doesn't exist or not recorded in database."
        else
            res.send JSON.stringify doc


exports.report = report
exports.get_matches = get_matches
