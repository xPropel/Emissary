angular.module("emissaryApp", ['ui.bootstrap']).factory "MatchReportFactory", ($http) ->
  
  return {
    getMatchData: (callback) ->
      # Load Match Report Json File using $http.get
      $http.get("udes1.json").success(callback)
    getItemData: (callback) ->
      # Load Item Data CSV File using $http.get
      $http.get("item_data.csv").success(callback)
  }
  
.controller "MatchReportCtrl", ($scope, MatchReportFactory) ->

  MatchReportFactory.getMatchData (results) ->
    $scope.matchData = results
  
  MatchReportFactory.getItemData (results) ->
    $scope.itemData = $.parse(results).results

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
    
    return mode

  $scope.getGameLengthStr = () ->
    # Return Game Duration in MM:SS
    if not $scope.matchData then return "invalid"
    minutes = Math.floor($scope.matchData.gameLength/60)
    seconds = Math.floor($scope.matchData.gameLength%60)
    seconds = "0" + seconds if seconds.toString().length is 1
    return minutes + ":" + seconds

  $scope.getGameLengthMin = () ->
    # Return Game Duration in Minutes
    if not $scope.matchData then return 0
    return $scope.matchData.gameLength/60

  ###
  #Table Info
  ###
  $scope.getTeamString = (id) ->
    # Return "Blue Team" or "Purple Team"
    if id is 100 then "Blue Team" else "Purple Team"

  $scope.getTeamColor = (id) ->
    # Return Blue or Purple Color
    ###
    TODO: Actually make the colors change for both the header and the top of page VICTORY thing
    ###
    if id is 100 then "color:'#5CADFF'" else "color:'#D659FF'"

  $scope.getPlayerStatistics = (summoner, statStr) ->
    # Return the Value of the Stat (Within .statistics)
    stat = val.value for val in summoner.statistics when val.statTypeName == statStr
    # Deal with Specific Cases
    ###
    if statStr is "GOLD_EARNED"
      stat = (Math.round stat / 100) / 10 # 1 Decimal Place
    ###
    return stat

  $scope.getChampIcon = (summoner) ->
    # Return the Champion Icon
    "champion_icons/" + summoner.skinName + ".png"

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

  $scope.getItemIcon = (itemId) ->
    # Return the Item Icon
    directory = "item_icons/"
    return directory + itemId + ".png"

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
