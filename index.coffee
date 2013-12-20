###
League of Legends Tournament Code Generator
###

window.update = () ->

  # String-Format the Tournament Code Endpoint
  players  = if getMap() is 4 then 3 else 5
  endpoint = ["pvpnet://lol/customgame/joinorcreate"
               "map#{getMap()}"
              "pick#{getMode()}"
              "team#{players}"
              "spec#{getSpec()}"
              ""].join "/"

  # Generate the Lobby Identifier String
  id = Math.random().toString(36).substring(2, 7)
  lobby = btoa JSON.stringify
    name:     lobbyName.value or "Emissary " + id
    password: lobbyPass.value or ""
  tournamentCode.value = endpoint + lobby

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

getSpec = () ->

  # Determine the Selected Spectator Format
  switch specs[specs.selectedIndex].text
    when "All"     then return "ALL"
    when "Friends" then return "FRIENDSONLY"
    when "Lobby"   then return "LOBBYONLY"
    when "None"    then return "NONE"

