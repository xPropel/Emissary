mdb = require "./mdb"
email = require "./email"

MDB_URL = process.env.MONGOHQ_URL || "mongodb://localhost/test"
MDB_COLL = process.env.MONGO_COLL || "games"

report = (req, res) ->
    if "gameId" of req.body
        mdb.set MDB_URL, MDB_COLL, req.body

        recipients = req.body.tournamentMetaData.passbackDataPacket
        #email.send_email recipients, "match@report", "Match Report", "http://#{req.host}/#?matchId=#{req.body.gameId}"
        email.send_email recipients, "match@report", "Match Report", "http://#{req.host}/matches/#{req.body.gameId}"

    res.send()

get_matches = (req, res) ->
    mdb.get MDB_URL, MDB_COLL, parseInt(req.params.gameid, 10), (err, doc) ->
        if err
            console.log "[#{req.params.gameid}] #{err}"
            res.send "Error"
        else
            res.send JSON.stringify doc


exports.report = report
exports.get_matches = get_matches

