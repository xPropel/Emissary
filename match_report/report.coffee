angular.module("emissaryApp", []).factory "MatchReportFactory", ($http) ->
  
  return {
    report: (callback) ->
      $http.get("udes4.json").success(callback)
  }
  
.controller "MatchReportCtrl", ($scope, MatchReportFactory) ->

  MatchReportFactory.report (results) ->
    $scope.data = results

  $scope.getStat = (summoner, statStr) ->
    # Return the Value of the Requested Statistic
    return val.value for val in summoner.statistics when val.statTypeName == statStr

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

  $scope.getBgcolor = (summoner) ->
    #Return Background Color (Win/Lose)
    if summoner.isWinningTeam then "#00AA00" else "#AA0000"

  $scope.getChampIcon = (summoner) ->
    return "champion_icons/"+summoner.skinName+".png"

  $scope.getChamp = (summoner) ->
    return summoner.skinName

  $scope.getLevel = (summoner) ->
    return summoner.skinName




