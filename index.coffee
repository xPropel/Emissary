###
Tournament Code Client Endpoint
endpoint = "pvpnet://lol/customgame/joinorcreate/map#{}/pick#{}/team#{}/spec#{}/"
###

# Called on Select or Input Element Change
window.update = (config={}) ->

  # Determine the Selected Map
  switch maps[maps.selectedIndex].text
    when "Summoner's Rift"  then config.map = 1
    when "Howling Abyss"    then config.map = 8
    when "Crystal Scar"     then config.map = 7
    when "Twisted Treeline" then config.map = 4

  # Determine the Selected Gameplay Mode
  switch modes[modes.selectedIndex].text
    when "Blind Pick"       then config.mode = 1
    when "All Random"       then config.mode = 4
    when "Draft Mode"       then config.mode = 2
    when "Tournament Draft" then config.mode = 6

  # Determine the Selected Spectator Format
  switch specs[specs.selectedIndex].text
    when "All"     then config.spec = "ALL"
    when "Friends" then config.spec = "FRIENDSONLY"
    when "Lobby"   then config.spec = "LOBBYONLY"
    when "None"    then config.spec = "NONE"

  # String-Format the Tournament Code Endpoint
  config.players = if config.map is 4 then 3 else 5
  endpoint = ["pvpnet://lol/customgame/joinorcreate"
               "map#{config.map}"
              "pick#{config.mode}"
              "team#{config.players}"
              "spec#{config.spec}"
              ""].join "/"

  # Generate the Lobby Identifier String
  config = btoa JSON.stringify
    name:     lobbyName.value or "Insert Lobby Name"
    password: lobbyPass.value or ""
  tournamentCode.value = endpoint + config
