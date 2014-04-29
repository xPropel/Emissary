dns = require "dns"

mdb = require "./mdb"
email = require "./email"

MDB_URL = process.env.MONGOHQ_URL || "mongodb://localhost/test"
MDB_COLL = process.env.MONGO_COLL || "games"

report = (req, res) ->
    #console.log req.ip
    #dns.reverse req.ip, (err, doms) -> console.log err or doms

    if "gameId" of req.body
        mdb.set MDB_URL, MDB_COLL, req.body

        recipients = req.body.tournamentMetaData.passbackDataPacket
        email.send_email recipients, "match@report", "Match Report", JSON.stringify req.body
        res.send("#{req.body.gameId}\n")

    else
        res.send("received\n")

exports.report = report

