###
League of Legends Tournament Code Generator
###

window.update = () ->

  # Determine the Endpoint
  endpoint = formatEndpoint()
  #teams    = updateTeams()
  $("#single").val('')
  $("#multi").text('')

  # Generate New Tournament Codes
  $("#single").val(encodeSingle endpoint)
  $("#multi").text(encodeMulti  endpoint)

encodeMulti = (endpoint, codes="") ->

  # Generate Multiple Identifiers
  for index in [1..$("#number").val()]
    index = "" unless $("#index").prop("checked")
    codes += encodeSingle(endpoint, index) + "\n"
  return codes unless $("#number").val() <= 0

encodeSingle = (endpoint, index=null) ->

  # Generate Pseudorandom Identifiers
  lrand = Math.random().toString(36).substring(2, 7)
  prand = Math.random().toString(36).substring(0, 9)

  # Generate the Lobby Identifier String
  rhash = $("#rhash").prop("checked")
  lname = lobbyName.value or "Custom Lobby"
  if index then lname += " ~" + index
  if rhash then lname += " #" + lrand
  if lname is "Custom Lobby" and not rhash
    lname += " #" + lrand

  # Generate the Lobby Password
  lpass = lobbyPass.value or ""
  rpass = $("#rpass").prop("checked")
  if rpass then lpass = prand
  switch rpass # Enable Input
    when true  then $("#lobbyPass").attr("disabled", rpass)
    when false then $("#lobbyPass").attr("disabled", rpass)

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

    # Legacy Game Modes
    when "Blind Draft"      then return 7
    when "One for All"      then return 14

getPlayers = () ->

  # Return the Appropriate Number of Players
  if maps[maps.selectedIndex].text is "Twisted Treeline"
    return 3 if players[players.selectedIndex].text >= 3
  return players[players.selectedIndex].text

getSpec = () ->

  # Determine the Selected Spectator Format
  switch specs[specs.selectedIndex].text
    when "All"     then return "ALL"
    when "Friends" then return "DROPINONLY"
    when "Lobby"   then return "LOBBYONLY"
    when "None"    then return "NONE"

updateTeams = () ->

  # Modify Player Capacity on Twisted Treeline
  if maps[maps.selectedIndex].text is "Twisted Treeline"
    $("#players").val(3)
    $("#players option[value='4']").remove()
    $("#players option[value='5']").remove()

  # Restore Player Capacity for All Other Maps
  else if $("#players option").length < 5
    $("#players").append('<option value="4">4</option>')
    $("#players").append('<option value="5">5</option>')
    $("#players").val(5) if $("#players").val() < 5

processStringQuery = (query) ->

  # Default to Lowercase Keys
  query[key.toLowerCase()] = query[key].replace(/\/$/, "") for key of query

  # Fill in Game Dropdown Options
  for key in [ "map", "mode", "player", "spec" ]
    if parseInt(query[key]) in [0..$("##{key}s").prop("length")-1]
      $("##{key}s").prop("selectedIndex", query[key]-1)

  # Fill in Extra Lobby Options
  for key in [ "rpass", "rhash", "index" ]
    $("##{key}").prop("checked", query[key])

  # Fill in Lobby Name and Password
  if query.lobby then $("#lobbyName").val(decodeURI query.lobby)
  if query.pass  then $("#lobbyPass").val(decodeURI query.pass)
  if query.codes then $("#number")   .val(query.codes)
  return update()

do () ->

  # Set Default Attributes on Elements
  $("#players").val(5)
  $("#lobbyName").focus()
  $("#lobbyName").attr("placeholder", "Enter a Lobby Name")
  $("#lobbyPass").attr("placeholder", "Enter a Password (Optional)")

  # Create and Process If a String Query is Provided
  query = new URI(window.location.search).search(true) # Uses URI.js
  if (Object.keys(query).length) then processStringQuery(query)


  # Bind Events to Update Selectors
  $("select")    .bind "change", update
  $("input")     .bind "input",  update
  $("#maps")     .bind "change", updateTeams # Update Team Size
  $(":checkbox") .bind "change", update
  
