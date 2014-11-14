mclient = require("mongodb").MongoClient


get = (mdb_url, mdb_coll, gameid, cb) ->
    mclient.connect mdb_url, (err, db) ->
        if err
            cb err
            return

        coll = db.collection(mdb_coll)
        coll.find({gameId:gameid}, {_id:0}).limit(1).toArray (err, docs) ->
            if docs.length == 0
                cb "Not found."
            else
                cb null, docs[0]


set = (mdb_url, mdb_coll, doc) ->
    mclient.connect mdb_url, (err, db) ->
        if !err
            coll = db.collection(mdb_coll)
            coll.find({gameId:doc.gameId}, {gameId:1}).limit(1).count (e,r) ->
                if r == 0 then coll.insert doc, w: 1, (err, result) ->
                    db.close()


exports.get = get
exports.set = set

