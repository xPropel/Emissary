angular.module("emissaryApp", []).factory "MatchReportFactory", ($http) ->
  
  return {
    report: (callback) ->
      $http.get("udes4.json").success(callback)
  }
  
.controller "MatchReportCtrl", ($scope, MatchReportFactory) ->

  MatchReportFactory.report (results) ->
    $scope.data = results

  this.chartDisplay = "cs"
  
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

  $scope.getTeamColor = (index) ->
    # Return Color for Blue or Purple Team
    if index is 0 then "#0000FF" else "#993399"

  $scope.getTeamString = (index) ->
    # Return "Blue" or "Purple"
    if index is 0 then "Blue" else "Purple"

  $scope.getWinLoseColor = (summoner) ->
    # Return Background Color (Win/Lose)
    if summoner and summoner.isWinningTeam then "#33CC33" else "#D63333"

  $scope.getWinLoseString = (summoner) ->
    # Return "Victory" or "Defeat"
    if summoner and summoner.isWinningTeam then "Victory" else "Defeat"

  $scope.getChampIcon = (summoner) ->
    "champion_icons/" + $scope.getPlayerStat(summoner, "skinName") + ".png"

  $scope.getTeamColorShadow = (index) ->
    # Return Text Shadow for Blue or Purple Team
    if index is 0 then "text-shadow: 0 0 0.2em #0066FF" else "text-shadow: 0 0 0.2em #CC3399"

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

  $scope.loadDamageChart = (summoner, element) ->

    $('#' + element).highcharts
      chart:
        type: "bar"

      title:
        text: "Damage Distribution"

      xAxis:
        categories: ["Damage Dealt", "Damage Received"]

      yAxis:
        title:
          text: "Damage"
        min: 0
        reversedStacks: false

      legend:
        title:
          text: "Damage Breakdown"
        backgroundColor: "#FFFFFF"

      plotOptions:
        series:
          stacking: "normal"

      series: [
        name: "True Damage"
        data: [$scope.getDetailedPlayerStat(summoner, "TRUE_DAMAGE_DEALT_PLAYER"), $scope.getDetailedPlayerStat(summoner, "TRUE_DAMAGE_TAKEN")]
      ,
        name: "Physical Damage"
        data: [$scope.getDetailedPlayerStat(summoner, "PHYSICAL_DAMAGE_DEALT_PLAYER"), $scope.getDetailedPlayerStat(summoner, "PHYSICAL_DAMAGE_TAKEN")]
      ,
        name: "Magic Damage"
        data: [$scope.getDetailedPlayerStat(summoner, "MAGIC_DAMAGE_DEALT_PLAYER"), $scope.getDetailedPlayerStat(summoner, "MAGIC_DAMAGE_TAKEN")]
      ]

  $scope.loadCsChart = (summoner, element) ->

    $('#' + element).highcharts
      chart:
        type: "bar"

      title:
        text: "Farm Distribution"

      xAxis:
        categories: ["Creep Score"]

      yAxis:
        title:
          text: "Minions/Monsters Killed"
        min: 0
        reversedStacks: false

      legend:
        title:
          text: "Type of CS"
        backgroundColor: "#FFFFFF"

      plotOptions:
        series:
          stacking: "normal"

      series: [
        name: "Lanes"
        data: [$scope.getDetailedPlayerStat(summoner, "MINIONS_KILLED") - $scope.getDetailedPlayerStat(summoner, "NEUTRAL_MINIONS_KILLED_YOUR_JUNGLE") - $scope.getDetailedPlayerStat(summoner, "NEUTRAL_MINIONS_KILLED_ENEMY_JUNGLE")]
      ,
        name: "Own Jungle"
        data: [$scope.getDetailedPlayerStat(summoner, "NEUTRAL_MINIONS_KILLED_YOUR_JUNGLE")]
      ,
        name: "Counter Jungle"
        data: [$scope.getDetailedPlayerStat(summoner, "NEUTRAL_MINIONS_KILLED_ENEMY_JUNGLE")]
      ]

  $scope.showDetails = (summoner, teamStr) ->
    # Shows the Hidden Details
    document.getElementById(teamStr + $scope.getPlayerStat(summoner, 'skinName') + "Details").style.display = ""

    if not this.chartDisplay then this.chartDisplay = "damage"
    if this.chartDisplay is "damage"
      $scope.loadDamageChart(summoner, teamStr + summoner.skinName + "Chart")
    else if this.chartDisplay is "cs"
      $scope.loadCsChart(summoner, teamStr + summoner.skinName + "Chart")
    return

  $scope.toggleDetails = (summoner, teamStr) ->
    # Toggle the Visibility of the Hidden div with Detailed Stats for Specified Summoner
    if document.getElementById(teamStr + summoner.skinName + "Details").style.display is ""
      document.getElementById(teamStr + summoner.skinName + "Details").style.display = "none"
    else 
      $scope.showDetails(summoner, teamStr)
    return
