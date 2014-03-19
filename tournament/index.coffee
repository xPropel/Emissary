angular.module("generatorApp", []).controller "OptionsCtrl", ($scope) ->

  $scope.map = "Summoner's Rift"
  $scope.mode = "Blind Pick"
  $scope.player = 5
  $scope.spec = "All"

  $scope.update = () ->

    # Determine the Endpoint
    endpoint = formatEndpoint()
    $scope.single = ''
    $scope.multi = ''

    # Generate New Tournament Codes
    $scope.single = encodeSingle endpoint
    $scope.multi =  encodeMulti  endpoint

  $scope.updateTeams = () ->

    # Select Maximum Player Count
    if $scope.map is "Twisted Treeline" then $scope.player = 3
    else $scope.player = 5

    $scope.update()

  encodeMulti = (endpoint, codes="") ->

    # Generate Multiple Identifiers
    for index in [1..$scope.number]
      index = "" unless $scope.index
      codes += encodeSingle(endpoint, index) + "\n"
    return codes unless $scope.number <= 0

  encodeSingle = (endpoint, index=null) ->

    # Generate Pseudorandom Identifiers
    lrand = Math.random().toString(36).substring(2, 7)
    prand = Math.random().toString(36).substring(0, 9)

    # Generate the Lobby Identifier String
    rhash = $scope.rhash
    lname = lobbyName.value or "Custom Lobby"
    if index then lname += " ~" + index
    if rhash then lname += " #" + lrand
    if lname is "Custom Lobby" and not rhash
      lname += " #" + lrand

    # Generate the Lobby Password
    lpass = lobbyPass.value or ""
    rpass = $scope.rpass
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
    switch $scope.map
      when "Summoner's Rift"  then return 1
      when "Howling Abyss"    then return 12
      when "Crystal Scar"     then return 8
      when "Twisted Treeline" then return 10

  getMode = () ->

    # Determine the Selected Gameplay Mode
    switch $scope.mode
      when "Blind Pick"       then return 1
      when "All Random"       then return 4
      when "Draft Mode"       then return 2
      when "Tournament Draft" then return 6

      # Legacy Game Modes
      when "Blind Draft"      then return 7
      when "One for All"      then return 14

  getPlayers = () ->

    # Determine the Number of Players
    return $scope.player

  getSpec = () ->

    # Determine the Selected Spectator Format
    switch $scope.spec
      when "All"     then return "ALL"
      when "Friends" then return "DROPINONLY"
      when "Lobby"   then return "LOBBYONLY"
      when "None"    then return "NONE"

  do () ->

    # Set Default Attributes on Elements
    $scope.player = 5
    document.getElementById("lobbyName").focus()
