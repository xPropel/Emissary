angular.module("emissaryApp", ['ui.bootstrap', 'ionic']).factory "MatchReportFactory", ($http) ->

  return {
    getMatchData: (callback, file) ->
      # Load Match Report Json File using $http.get
      # Return the Promised Json Object
      $http.get(file).success(callback)

    getItemData: (success, error, id) ->
      url = "https://prod.api.pvp.net"
      region = "na"
      key = "bd4466a9-7b6b-4c20-b151-70db062a9ad8"
      version = "4.6.3" # Has nothing to do with API version (currently 1.2)
      request = "#{url}/api/lol/static-data/#{region}/v1.2/item/#{id}?itemData=all&api_key=#{key}"

      $http.get(request, {cache: true}).success(success).error(error)
  }
  
.controller "MatchReportCtrl", ($scope, $location, MatchReportFactory) ->

  # Call getMatchData and Pass in the Callback Function
  # The Callback Function is Executed When the $http.get
  # Succeeds (calls success(callback))
  MatchReportFactory.getMatchData((data) ->
    # Executed upon Successful $http.get
    $scope.matchData = data
  , $location.search().matchId)

  $scope.items = []

  $scope.displayLevel = false

  ###
  #General Game Info
  ###
  $scope.getVictoryStr = () ->
    # Return String for Victory Header
    if not $scope.matchData or $scope.matchData.invalid
      return "Game Invalidated"
    player1 = $scope.matchData.teamPlayerParticipantsSummaries[0]
    if player1.teamId is 100 and player1.isWinningTeam or player1.teamId is 200 and not player1.isWinningTeam
      "Blue Team Victory"
    else if player1.teamId is 200 and player1.isWinningTeam or player1.teamId is 100 and not player1.isWinningTeam
      "Purple Team Victory"

  $scope.getGameModeStr = () ->
    # Return Game Mode in Natural Language
    if not $scope.matchData or $scope.matchData.invalid
      return "Invalid"
    if $scope.matchData.gameType is "CUSTOM_GAME"
      mode = "Custom "
    else if $scope.matchData.gametype is "TUTORIAL_GAME"
      mode = "Tutorial "
    if $scope.matchData.ranked
      mode = "Ranked "
    if $scope.matchData.gameMode is not "CLASSIC"
      mode += " " + $scope.matchData.gameMode
    mode += $scope.matchData.teamPlayerParticipantsSummaries.length + "v" + $scope.matchData.otherTeamPlayerParticipantsSummaries.length 
    mode

  $scope.getGameLengthStr = () ->
    # Return Game Duration in MM:SS
    if not $scope.matchData then return "invalid"
    minutes = Math.floor($scope.matchData.gameLength/60)
    seconds = Math.floor($scope.matchData.gameLength%60)
    seconds = "0" + seconds if seconds.toString().length is 1
    minutes + ":" + seconds

  $scope.getGameLengthMin = () ->
    # Return Game Duration in Minutes
    if not $scope.matchData then return 0
    $scope.matchData.gameLength/60

  ###
  #Table Info
  ###
  $scope.getTeamString = (id) ->
    # Return "Blue Team" or "Purple Team"
    if id is 100
      "Blue Team"
    else if id is 200
      "Purple Team"
    else
      "Neutral"

  $scope.getTeamColor = (id) ->
    # Return Blue or Purple Color
    if id is -1
      if $scope.getVictoryStr() is "Blue Team Victory"
        "#5CADFF" # Blue
      else if $scope.getVictoryStr() is "Purple Team Victory"
        "#D659FF" # Purple
      else
        "#9E9E9E" # Gray
    else if id is 100
      "#5CADFF" # Blue
    else if id is 200
      "#D659FF" # Purple
    else
      "#9E9E9E" # Gray

  $scope.getPlayerStatistics = (summoner, statStr) ->
    # Return the Value of the Stat (Within .statistics)
    stat = val.value for val in summoner.statistics when val.statTypeName == statStr
    stat

  $scope.getChampionLink = (summoner) ->
    # Return the Champion Link (on LoLKing.net)
    "http://www.lolking.net/champions/" + summoner.skinName

  $scope.getChampIcon = (summoner) ->
    # Return the Champion Icon
    "champion_icons/" + summoner.skinName + ".png"

  $scope.getSummonerLink = (summoner) ->
    # Return the Summoner Link to op.gg
    "http://na.op.gg/summoner/userName=" + summoner.summonerName

  $scope.getSummonerLevel = (summoner) ->
    $scope.displayLevel = true if summoner.level is not 30
    # Return the Summoner Level
    summoner.level

  $scope.getSpellIcon = (spellId) ->
    # Return the Summoner Icon
    directory = "summoner_spell_icons/"
    switch spellId
      when 1  then return directory + "Cleanse.png"
      when 2  then return directory + "Clairvoyance.png"
      when 3  then return directory + "Exhaust.png"
      when 4  then return directory + "Flash.png"
      # No 5
      when 6  then return directory + "Ghost.png"
      when 7  then return directory + "Heal.png"
      # No 8, 9
      when 10 then return directory + "Revive.png"
      when 11 then return directory + "Smite.png"
      when 12 then return directory + "Teleport.png"
      when 13 then return directory + "Clarity.png"
      when 14 then return directory + "Ignite.png"
      # No 15, 16
      when 17 then return directory + "Garrison.png"
      # No 18, 19, 20
      when 21 then return directory + "Barrier.png"

  $scope.parseInt = (num) ->
    # Return Parsed Integer (Used in .jade)
    return Math.round(num)

  $scope.getAverageCs = (summoner) ->
    # Return CS in CS/Minutes
    return Math.round($scope.getPlayerStatistics(summoner, "MINIONS_KILLED")/$scope.getGameLengthMin()*10)/10

  $scope.getAverageGold = (summoner) ->
    # Return Gold in Gold/Minutes
    return Math.round($scope.getPlayerStatistics(summoner, "GOLD_EARNED")/$scope.getGameLengthMin()*10)/10

  $scope.getSummonerItemId = (summoner, index) ->
    # Return the Item ID of the Item
    $scope.getPlayerStatistics(summoner, "ITEM" + index)

  $scope.getItemLink = (itemId) ->
    # Return the Item Link (on LoLKing.net)
    if itemId
      "http://www.lolking.net/items/" + itemId
    else
      "#"

  $scope.getItemIcon = (itemId) ->
    # Return the Item Icon
    "item_icons/" + itemId + ".png"

  $scope.getItem = (id) ->
    # Return the Item Object
    if not $scope[id]
      MatchReportFactory.getItemData((data) ->
        if data then $scope[id] = data
      , (data, status) ->
        $scope[id] = status
      , id)
    $scope[id]

  $scope.getItemTooltip = (itemId) ->
    # Return the Item Tooltip

    return "STOP ASKING FOR ITEMS sir"
    if itemId is 0 then return ""

    item = $scope.getItem(itemId)
    if not item or item is 404 or Object.keys(item).length <= 1
      return "<em>Item Unavailable</em>"
    #console.log $scope.items
    #tooltip = item.description for item in $scope.items when item.id is itemId
    #tooltip

  $scope.initTooltip = (itemId) ->
    # Set data-tooltip-html-unsafe of item-#{itemId} to Item Information
    0
    ###
    #doesn't work...
    
    if document.getElementsByClassName("item-#{itemId}")[0].getAttribute("data-tooltip-html-unsafe") is "lololol"
      element.setAttribute("data-tooltip-html-unsafe", $scope.getItemTooltip(itemId)) for element in document.getElementsByClassName("item-#{itemId}")
      #console.log "set success..????"
    ###

  $scope.getTeamTotal = (team, statStr) ->
    # Return the Sum of the Team's Stat
    if not $scope.matchData
      return 0
    sum = $scope.matchData[team].reduce ((total, summoner) -> total + $scope.getPlayerStatistics(summoner, statStr)), 0
    return (sum * 10) / 10

  ###
  #Table Formatting/ Color
  ###
  $scope.getRowColor = (rowIndex) ->
    # Return Alternating Color for Rows
    if rowIndex % 2 is 0 then "rgba(255, 255, 255, 0.04)" else "rgba(255, 255, 255, 0.08)"

  ###
  #Misc.
  ###
  

  ###
  #Startup Routines
  ###
  do () ->
    console.log "nothing to see here"