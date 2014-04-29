mclient = require("mongodb").MongoClient


set = (mdb_url, mdb_coll, doc) ->
    mclient.connect mdb_url, (err, db) ->
        if !err
            coll = db.collection(mdb_coll)
            coll.find({gameId:doc.gameId}, {gameId:1}).limit(1).count (e,r) ->
                if r == 0 then coll.insert doc, w: 1, (err, result) ->
                    db.close()


exports.set = set

