app = () ->

  bower  = "#{__dirname}/../bower_components/"
  client = "#{__dirname}/../client/"

  @use "/static", require("express") .static(bower)
  @use            require("harp")    .mount(client)
  return this

app = app.call(do require "express")
app.post("/match_report", require("connect").json(), require("./matchreport").report)
app.listen(process.env.PORT or 8080)
