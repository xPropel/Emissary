angular.module("emissaryApp", []).factory "MatchReportFactory", ($http) ->
  
  return {
    report: (callback) ->
      $http.get("udes4.json").success(callback)
  }
  
.controller "MatchReportCtrl", ($scope, MatchReportFactory) ->

  MatchReportFactory.report (results) ->
    $scope.data = results

  $scope.getPlayerStat = (summoner, statStr) ->
    # Return the Value of Basic Player Stat
    summoner[statStr]

  $scope.getDetailedPlayerStat = (summoner, statStr) ->
    # Return the Value of the Stat (Within .statistics)
    stat = val.value for val in summoner.statistics when val.statTypeName == statStr

    # Deal with Specific Cases
    if statStr is "GOLD_EARNED"
      stat = (Math.round stat / 100) /10

    return stat

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

  $scope.getTeamColor = (index) ->
    # Return Color for Blue or Purple Team
    if index is 0 then "#0000FF" else "#993399"

  $scope.getWinLoseColor = (summoner) ->
    # Return Background Color (Win/Lose)
    if summoner.isWinningTeam then "#FFAAFF" else "#AAFFFF"

  $scope.getChampIcon = (summoner) ->
    "champion_icons/" + $scope.getPlayerStat(summoner, "skinName") + ".png"
