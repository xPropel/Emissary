angular.module("masteryApp", ["RightClickDirective"])

.controller "MasteryCtrl", ($scope, $location, $http) ->
  $scope.mastery_data = {}

  $http.get("/assets/json/mastery.json")
    .then (res) ->
      $scope.mastery_data = res.data
      $scope.load()

  $scope.isNull = (mastery) ->
    return typeof mastery is "undefined" or mastery is null

  $scope.load = () ->
    $scope.mastery_data.tree.total = 0

    # Create a Blank "Pre-requisite" Mastery
    $scope.mastery_data.data["0"] = {}
    $scope.mastery_data.data["0"].name = ""
    $scope.mastery_data.data["0"].description = []
    $scope.mastery_data.data["0"].prereq = 0
    $scope.mastery_data.data["0"].reqby = 0
    $scope.mastery_data.data["0"].rank = 0
    $scope.mastery_data.data["0"].ranks = 0

    # Create Extra Fields for Each Tree/Mastery
    for tree in ["Offense", "Defense", "Utility"]
      depth = 0
      $scope.mastery_data.tree[tree].total = 0                            # Total for a Specific Tree
      for level in $scope.mastery_data.tree[tree]
        depth++
        for mastery in level
          if not $scope.isNull(mastery)
            $scope.mastery_data.data[mastery.masteryId].rank = 0          # Current Rank of Mastery
            $scope.mastery_data.data[mastery.masteryId].deep = depth-1    # Depth of Mastery
            $scope.mastery_data.data[mastery.masteryId].tree = tree       # Which Tree This Mastery Belongs Under
            $scope.mastery_data.data[mastery.masteryId].reqby = 0         # Other Way of Prereq
            if $scope.mastery_data.data[mastery.masteryId].prereq > 0
              $scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].reqby = mastery.masteryId

  $scope.available = (mastery) ->
    return (($scope.mastery_data.data[mastery.masteryId].rank > 0 and # Rank Must Be In Between 0 and Max
      $scope.mastery_data.data[mastery.masteryId].rank < $scope.mastery_data.data[mastery.masteryId].ranks) or # OR
      ($scope.checkTreeReq(mastery) and
      $scope.checkMasteryReq(mastery) and
      $scope.mastery_data.tree.total < 30)) unless $scope.isNull(mastery) # Max Number of Mastery Points

  $scope.unavailable = (mastery) ->
    return not $scope.full(mastery) and not $scope.available(mastery) unless $scope.isNull(mastery) # Neither available() NOR full()

  $scope.full = (mastery) ->
    return $scope.mastery_data.data[mastery.masteryId].rank is $scope.mastery_data.data[mastery.masteryId].ranks\ # Current Rank == Max Rank
     unless $scope.isNull(mastery)

  $scope.getIconPath = (mastery) ->
    (return "/assets/images/mastery/#{mastery.masteryId}.png" if $scope.full(mastery) or $scope.available(mastery)
    return "/assets/images/mastery/gray_#{mastery.masteryId}.png" if $scope.unavailable(mastery)) unless $scope.isNull(mastery)

  $scope.getReqBackground = (mastery) ->
    (return "/assets/images/mastery/req_full.png"          if $scope.full(mastery)
    return "/assets/images/mastery/req_available.png"      if $scope.available(mastery)
    return "/assets/images/mastery/req_unavailable.png"    if $scope.unavailable(mastery))\
     unless $scope.isNull(mastery) or $scope.mastery_data.data[mastery.masteryId].prereq <= 0

  $scope.getBorderBackground = (mastery) ->
    (return "/assets/images/mastery/border_full.png"       if $scope.full(mastery)
    return "/assets/images/mastery/border_available.png"   if $scope.available(mastery)
    return "/assets/images/mastery/border_unavailable.png" if $scope.unavailable(mastery))\
     unless $scope.isNull(mastery)

  $scope.getRankBackground = (mastery) ->
    (return "/assets/images/mastery/rank_full.bmp"         if $scope.full(mastery)
    return "/assets/images/mastery/rank_available.png"     if $scope.available(mastery)
    return "/assets/images/mastery/rank_unavailable.png"   if $scope.unavailable(mastery))\
     unless $scope.isNull(mastery)

  # Get Text Color of Rank/Max of Mastery
  $scope.getRankStrColor = (mastery) ->
    (return "#e0df00"                               if $scope.full(mastery)
    return "#42cc00"                                if $scope.available(mastery)
    return "#747474"                                if $scope.unavailable(mastery))\
     unless $scope.isNull(mastery)

  # Get Rank/Max of Mastery
  $scope.getRankStr = (mastery) ->
    return "#{$scope.mastery_data.data[mastery.masteryId].rank}/#{$scope.mastery_data.data[mastery.masteryId].ranks}"\
     unless $scope.isNull(mastery)

  # Get {Offense: Rank}/ {Defense: Rank}/ {Utility: Rank}
  $scope.getTreeRank = (tree) ->
    return $scope.mastery_data.tree[tree].total unless typeof $scope.mastery_data.tree is "undefined" or $scope.mastery_data.tree is null

  # Add a Point to Mastery
  $scope.increment = (mastery) ->
    # Increase Rank
    ($scope.mastery_data.data[mastery.masteryId].rank++
    $scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree].total++
    $scope.mastery_data.tree.total++)\
     unless $scope.isNull(mastery) or not $scope.available(mastery) or $scope.full(mastery) or $scope.mastery_data.tree.total >= 30

  # Returns If This Mastery Fulfilled Depth Requirements
  $scope.checkTreeReq = (mastery) ->
    return $scope.mastery_data.data[mastery.masteryId].deep * 4 <= $scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree].total unless $scope.isNull(mastery)

  # Returns If This Mastery Fulfilled Its Parent Requirements
  $scope.checkMasteryReq = (mastery) ->
    return $scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].ranks is 0 or # Non-existant Pre-requisite OR
      $scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].rank is $scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].ranks unless $scope.isNull(mastery)

  # Decrease a Point from Mastery
  $scope.decrement = (mastery) ->
    (if ($scope.full(mastery) or ($scope.mastery_data.data[mastery.masteryId].rank > 0 and $scope.available(mastery))) and
      $scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].reqby].rank is 0 # Check for Pre-requisites
        sum = 0
        deepest = $scope.mastery_data.data[$scope.getDeepestMasteryId(mastery)].deep # Deepest Ranked Mastery
        for depth in [0..deepest-1] by 1 # Only Need to Check Until Deepest Ranked Mastery
          for m in $scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree][depth]
            sum += $scope.mastery_data.data[m.masteryId].rank unless $scope.isNull(m) # Count Total Ranks From 0 To depth
          if $scope.mastery_data.data[mastery.masteryId].deep <= depth and sum - 1 < (depth+1)*4
            return # Cancel decrement() If Subtracting the Rank Will Fail Requirements

        # Decrase Rank
        $scope.mastery_data.data[mastery.masteryId].rank--
        $scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree].total--
        $scope.mastery_data.tree.total--) unless $scope.isNull(mastery)

  # Get the Deepest Mastery with Rank > 0 In Current Tree
  $scope.getDeepestMasteryId = (mastery) ->
    (id = mastery.masteryId
    for depth in [$scope.mastery_data.data[mastery.masteryId].deep..$scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree].length-1] by 1
      for m in $scope.mastery_data.tree[$scope.mastery_data.data[mastery.masteryId].tree][depth]
        (if $scope.mastery_data.data[m.masteryId].rank > 0
          id = m.masteryId
          depth++) unless $scope.isNull(m)
    return id) unless $scope.isNull(mastery)

  # Get Tree Color
  $scope.getTreeColor = (tree) ->
    return "#b31c00" if tree is "Offense"
    return "#309030" if tree is "Defense"
    return "#49a8f6" if tree is "Utility"

  # Build Mastery tooltip
  $scope.getTooltip = (mastery) ->
    (html =  "<span style=color:#{$scope.getTreeColor($scope.mastery_data.data[mastery.masteryId].tree)};font-size:17px>#{$scope.mastery_data.data[mastery.masteryId].name}</span>"
    html += "<br><br>"
    html += "<span style=color:#{$scope.getRankStrColor(mastery)}>Rank: #{$scope.getRankStr(mastery)}</span>"
    if not $scope.checkTreeReq(mastery)
      html += "<br>"
      html += "<br>"
      html += "<span style=color:red>Requires #{$scope.mastery_data.data[mastery.masteryId].deep*4} points in #{$scope.mastery_data.data[mastery.masteryId].tree}.</span>"
    if not $scope.checkMasteryReq(mastery)
      html += "<br>"
      html += "<span style=color:red>Requires #{$scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].ranks} points in #{$scope.mastery_data.data[$scope.mastery_data.data[mastery.masteryId].prereq].name}.</span>"
    html += "<br>"
    html += "<br>"
    html += "<span style=color:white>"
    if $scope.mastery_data.data[mastery.masteryId].rank is 0
      html += $scope.mastery_data.data[mastery.masteryId].description[0]
    else
      html += $scope.mastery_data.data[mastery.masteryId].description[$scope.mastery_data.data[mastery.masteryId].rank-1]
    if $scope.mastery_data.data[mastery.masteryId].rank isnt 0 and not $scope.full(mastery)
      html += "<br>"
      html += "<br>"
      html += "Next Rank:"
      html += "<br>"
      html += $scope.mastery_data.data[mastery.masteryId].description[$scope.mastery_data.data[mastery.masteryId].rank]
    html += "</span>"
    return html) unless $scope.isNull(mastery)