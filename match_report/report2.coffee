angular.module("emissaryApp", []).factory "MatchReportFactory", ($http) ->
  
  return {
    report: (callback) ->
      # Load Match Report Json File using $http.get
      $http.get("udes4.json").success(callback)
  }
  
.controller "MatchReportCtrl", ($scope, MatchReportFactory) ->

  MatchReportFactory.report (results) ->
    $scope.data = results

  $scope.data = null

  ###
  #General Game Info
  ###
  $scope.getVictoryStr = () ->
    # Return String for Victory Header
    if not $scope.data or $scope.data.invalid
      return "Game Invalidated"
    if $scope.data.teamPlayerParticipantsSummaries[0].isWinningTeam
      "Blue Team Victory"
    else if $scope.data.otherTeamPlayerParticipantsSummaries[0].isWinningTeam
      "Purple Team Victory"

  $scope.getGameModeStr = () ->
    # Return Game Mode in Natural Language
    if not $scope.data or $scope.data.invalid
      return "Invalid"
    if $scope.data.gameType is "CUSTOM_GAME"
      mode = "Custom " 
    else if $scope.data.ranked
      mode = "Ranked "
    mode += $scope.data.teamPlayerParticipantsSummaries.length + "v" + $scope.data.otherTeamPlayerParticipantsSummaries.length
    if $scope.data.gameMode is not "CLASSIC"
      mode += " " + $scope.data.gameMode
    return mode

  $scope.getGameLength = () ->
    # Return Game Druation in MM:SS
    if not $scope.data
      return "invalid"
    len = Math.floor($scope.data.gameLength/60) + ":" + Math.floor($scope.data.gameLength%60)
    return len

  ###
  #Table Info
  ###
  $scope.getTeamString = (index) ->
    # Return "Blue" or "Purple"
    if index is 0 then "Blue" else "Purple"

  $scope.getPlayerStatistics = (summoner, statStr) ->
    # Return the Value of the Stat (Within .statistics)
    stat = val.value for val in summoner.statistics when val.statTypeName == statStr
    # Deal with Specific Cases
    if statStr is "GOLD_EARNED"
      stat = (Math.round stat / 1000)
    return stat

  $scope.getChampIcon = (summoner) ->
    # Return the Champion Icon
    "champion_icons/" + summoner.skinName + ".png"

  $scope.getSpellIcon = (spellId) ->
    # Return the Summoner Icon
    directory = "summoner_spell_icons/"
    switch spellId
      when 3  then return directory + "Exhaust.png"
      when 4  then return directory + "Flash.png"
      when 6  then return directory + "Ghost.png"
      when 11 then return directory + "Smite.png"
      when 12 then return directory + "Teleport.png"
      when 14 then return directory + "Ignite.png"
      when 21 then return directory + "Barrier.png"

  $scope.getTeamTotal = (team, statStr) ->
    # Return the Sum of the Team's Stat
    if $scope.data
      sum = $scope.data[team].reduce ((total, summoner) -> total + $scope.getPlayerStatistics(summoner, statStr)), 0
    return sum

  ###
  #Table Formatting/ Color
  ###
  $scope.getRowColor = (rowIndex) ->
    # Return Alternating Color for Rows
    if rowIndex % 2 is 0 then "rgba(255, 255, 255, 0.04)" else "rgba(255, 255, 255, 0.08)"