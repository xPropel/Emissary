// Generated by CoffeeScript 1.7.1
angular.module("emissaryApp", []).factory("MatchReportFactory", function($http) {
  return {
    report: function(callback) {
      return $http.get("udes4.json").success(callback);
    }
  };
}).controller("MatchReportCtrl", function($scope, MatchReportFactory) {
  MatchReportFactory.report(function(results) {
    return $scope.data = results;
  });
  $scope.getStat = function(summoner, statStr) {
    var gold, val, _i, _j, _len, _len1, _ref, _ref1;
    if (statStr === "GOLD_EARNED") {
      _ref = summoner.statistics;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        val = _ref[_i];
        if (val.statTypeName === statStr) {
          gold = val.value;
        }
      }
      gold = (Math.round(gold / 100)) / 10;
      return gold;
    }
    _ref1 = summoner.statistics;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      val = _ref1[_j];
      if (val.statTypeName === statStr) {
        return val.value;
      }
    }
  };
  $scope.getSpellIcon = function(spellId) {
    var directory;
    directory = "summoner_spell_icons/";
    switch (spellId) {
      case 3:
        return directory + "Exhaust.png";
      case 4:
        return directory + "Flash.png";
      case 6:
        return directory + "Ghost.png";
      case 11:
        return directory + "Smite.png";
      case 12:
        return directory + "Teleport.png";
      case 14:
        return directory + "Ignite.png";
      case 21:
        return directory + "Barrier.png";
    }
  };
  $scope.getBgcolor = function(summoner) {
    if (summoner.isWinningTeam) {
      return "#FFAAFF";
    } else {
      return "#AAFFFF";
    }
  };
  $scope.getChampIcon = function(summoner) {
    return "champion_icons/" + summoner.skinName + ".png";
  };
  $scope.getChamp = function(summoner) {
    return summoner.skinName;
  };
  return $scope.getLevel = function(summoner) {
    return summoner.skinName;
  };
});