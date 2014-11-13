requests = require "requests"
json     = require "json"
blowfish = require "blowfish"
base64   = require "base64"
zlib     = require "zlib"

endpoint = (params) ->
	return "http://#{params.server}/observer-mode/rest/consumer/#{params.method}/#{params.platformId}/#{params.gameID}/#{params.parameter}/token"

params =
  server: "spectator.na.lol.riotgames.com:8088"
  method: ""
  platformId: "NA1"
  gameID: ""
  parameter: "1"

console.log endpoint(params)

params.gameID = "1593807856"
params.method = "getLastChunkInfo"

console.log endpoint(params)

r = requests.get endpoint(params)
r = json.loads r.content

params.method = "getKeyFrame"
params.parameter = r.keyFrameId - 1
s = requests.get endpoint(params)

bf = blowfish.new params.gameId, blowfish.MODE_ECB

encryptionkey = "X8l78ztiZDy4aAYtTUmq7dbMGk0A9jqL"

decodedkey = bf.decrypt(base64.b64decode encryptionkey)

paddingbytes = decodedkey[decodedkey.length-1].charCodeAt(0)
keywopadding = decodedkey[0...-paddingbytes] # Maybe .. only?

realencryptionkey = blowfish.new keywopadding, blowfish.MODE_ECB
datawpadding = realencryptionkey.decrypt s.content
paddingbytes = datawpadding[datawpadding.length-1].charCodeAt(0)
datawopadding = datawpadding[0...-paddingbytes] # Maybe .. only?

data = zlib.decompressobj zlib.MAX_WBITS|32
answer = data.decompress datawopadding

console.log answer