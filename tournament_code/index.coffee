angular.module("generatorApp", []).controller "OptionsCtrl", ($scope, $location) ->

  $scope.location = $location
  
  $scope.userOptions = {}
  $scope.outputs = {}

  #Initialization to Prevent Lobby Password from Disabling
  

  $scope.$watch("userOptions", () ->
    
    #Bind $scope variables to Query String
    for option of $scope.userOptions
      $location.search(option, $scope.userOptions[option])
    
  , true)
  
  $scope.$watch("location.search()", () ->

    #Bind Query String to $scope Variables
    $scope.userOptions.map = $location.search().map or "Summoner's Rift"
    $scope.userOptions.mode = $location.search().mode or "Blind Pick"
    $scope.userOptions.player = $location.search().player or 5
    $scope.userOptions.spec = $location.search().spec or "All"

    $scope.userOptions.lobbyName = $location.search().lobbyName
    $scope.userOptions.lobbyPass = $location.search().lobbyPass
    ###
    console.log "------before------"
    console.log "rpass: " + $scope.userOptions.rpass + ", " + $location.search().rpass
    console.log "rhash: " + $scope.userOptions.rhash + ", " + $location.search().rhash
    console.log "index: " + $scope.userOptions.index + ", " + $location.search().index
    ###
    $scope.userOptions.rpass = $location.search().rpass
    $scope.userOptions.rhash = $location.search().rhash
    $scope.userOptions.index = $location.search().index
    ###
    console.log "------after------"
    console.log "rpass: " + $scope.userOptions.rpass + ", " + $location.search().rpass
    console.log "rhash: " + $scope.userOptions.rhash + ", " + $location.search().rhash
    console.log "index: " + $scope.userOptions.index + ", " + $location.search().index
    ###

    #console.log typeof $location.search().rpass
    
    $scope.userOptions.number = parseInt $location.search().number or 0, 10

  ,true)

  $scope.update = () ->

    # Determine the Endpoint
    endpoint = formatEndpoint()
    $scope.outputs.single = ''
    $scope.outputs.multi = ''

    # Generate New Tournament Codes
    $scope.outputs.single = encodeSingle endpoint
    $scope.outputs.multi =  encodeMulti  endpoint

  $scope.updateTeams = () ->

    # Select Maximum Player Count
    if $scope.userOptions.map is "Twisted Treeline" then $scope.userOptions.player = 3
    else $scope.userOptions.player = 5

    $scope.update()

  encodeMulti = (endpoint, codes="") ->

    # Generate Multiple Identifiers
    for index in [1..$scope.userOptions.number]
      index = "" unless $scope.userOptions.index
      codes += encodeSingle(endpoint, index) + "\n"
    return codes unless $scope.userOptions.number <= 0

  encodeSingle = (endpoint, index=null) ->

    # Generate Pseudorandom Identifiers
    lrand = Math.random().toString(36).substring(2, 7)
    prand = Math.random().toString(36).substring(0, 9)

    # Generate the Lobby Identifier String
    rhash = $scope.userOptions.rhash
    lname = lobbyName.value or "Custom Lobby"
    if index then lname += " ~" + index
    if rhash then lname += " #" + lrand
    if lname is "Custom Lobby" and not rhash
      lname += " #" + lrand

    # Generate the Lobby Password
    lpass = lobbyPass.value or ""
    rpass = $scope.userOptions.rpass
    if rpass then lpass = prand

    # Format and Return a Tournament Code
    return endpoint + btoa JSON.stringify
      name: lname, password: lpass, report: "http://aqueous-ocean-9313.herokuapp.com/match_report/", extra: ["lin.darren95@gmail.com"]

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
    switch $scope.userOptions.map
      when "Summoner's Rift"  then return 1
      when "Howling Abyss"    then return 12
      when "Crystal Scar"     then return 8
      when "Twisted Treeline" then return 10

  getMode = () ->

    # Determine the Selected Gameplay Mode
    switch $scope.userOptions.mode
      when "Blind Pick"       then return 1
      when "All Random"       then return 4
      when "Draft Mode"       then return 2
      when "Tournament Draft" then return 6

      # Legacy Game Modes
      when "Blind Draft"      then return 7
      when "One for All"      then return 14

  getPlayers = () ->

    # Determine the Number of Players
    return $scope.userOptions.player

  getSpec = () ->

    # Determine the Selected Spectator Format
    switch $scope.userOptions.spec
      when "All"     then return "ALL"
      when "Friends" then return "DROPINONLY"
      when "Lobby"   then return "LOBBYONLY"
      when "None"    then return "NONE"
