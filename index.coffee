###
League of Legends Tournament Code Generator
###

$("#lobbyName").focus()
$("#lobbyName").attr("placeholder", "Enter a Lobby Name")
$("#lobbyPass").attr("placeholder", "Enter a Password (Optional)")

# Decode Existing Codes Option

window.update = () ->

  # Determine the Endpoint
  endpoint = formatEndpoint()
  $("#single").val('')
  $("#multi").text('')

  # Generate New Tournament Codes
  $("#single").val(encodeSingle endpoint)
  $("#multi").text(encodeMulti  endpoint)

encodeMulti = (endpoint, codes="") ->

  # Generate Multiple Identifiers
  for index in [1..10]
    index = "" unless $("#index").prop("checked")
    codes += encodeSingle(endpoint, index) + "\n"
  return codes

encodeSingle = (endpoint, index=null) ->

  # Generate Pseudorandom Identifiers
  lrand = Math.random().toString(36).substring(2, 7)
  prand = Math.random().toString(36).substring(0, 9)

  # Generate the Lobby Identifier String
  rhash = $("#rhash").prop("checked")
  lname = lobbyName.value or "Custom Lobby"
  if index then lname += " #" + index
  if rhash then lname += " !" + lrand

  # Generate the Lobby Password
  lpass = lobbyPass.value or ""
  rpass = $("#rpass").prop("checked")
  if rpass then lpass = prand

  # Format and Return a Tournament Code
  return endpoint + btoa JSON.stringify
    name: lname, password: lpass

formatEndpoint = () ->

  # String-Format the Tournament Code Endpoint
  return ["pvpnet://lol/customgame/joinorcreate"
           "map#{getMap()}"
          "pick#{getMode()}"
          "team#{getPlayers()}"
          "spec#{getSpec()}"
          ""].join "/"

getMap = () ->

  # Determine the Selected Map
  switch maps[maps.selectedIndex].text
    when "Summoner's Rift"  then return 1
    when "Howling Abyss"    then return 12
    when "Crystal Scar"     then return 8
    when "Twisted Treeline" then return 10

getMode = () ->

  # Determine the Selected Gameplay Mode
  switch modes[modes.selectedIndex].text
    when "Blind Pick"       then return 1
    when "All Random"       then return 4
    when "Draft Mode"       then return 2
    when "Tournament Draft" then return 6
    when "Blind Draft"      then return 7

    # Legacy Game Modes
    when "One for All"      then return 14

getPlayers = () ->

  # Determines the Correct Number of Players
  switch maps[maps.selectedIndex].text
    when "Twisted Treeline" then return 3
    else                         return 5

getSpec = () ->

  # Determine the Selected Spectator Format
  switch specs[specs.selectedIndex].text
    when "All"     then return "ALL"
    when "Friends" then return "DROPINONLY"
    when "Lobby"   then return "LOBBYONLY"
    when "None"    then return "NONE"

# Regenerate Tournament Codes While Typing
$("select")    .bind "change", update
$("input")     .bind "input",  update
$(":checkbox") .bind "change", update
