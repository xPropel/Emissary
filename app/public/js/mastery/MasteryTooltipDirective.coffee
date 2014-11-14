angular.module("masteryApp")

.directive "tooltips", [
  "$window"
  "$compile"
  "$timeout"
  ($window, $compile, $timeout) ->
    TOOLTIP_SMALL_MARGIN = 8 #px
    TOOLTIP_MEDIUM_MARGIN = 9 #px
    TOOLTIP_LARGE_MARGIN = 10 #px
    return (
      restrict: "A"
      scope: {}
      link: linkingFunction = (scope, element, attr) ->

        $scope = scope.$parent.$parent.$parent.$parent.$parent

        thisElement = angular.element(element[0])
        theTooltip = undefined
        theTooltipElement = undefined
        theTooltipHeight = undefined
        theTooltipWidth = undefined
        theTooltipMargin = undefined
        height = undefined
        width = undefined
        offsetTop = undefined
        offsetLeft = undefined
        #used both for margin top left right bottom
        title = attr.title or ""
        content = attr.tooltipContent or ""
        side = attr.tooltipSide or "top"
        size = attr.tooltipSize or "medium"

        mastery = JSON.parse(attr.tooltipMastery)

        htmlTemplate = 
          "<div class=\"tooltip tooltip-" + side + " tooltip-" + size + "\">" + 
          "<div class=\"tooltip-title\"> " + title + "</div>" + 
          "<div class='content'></div>" +
          "<span class=\"tooltip-caret\"></span>" + "</div>"

        #create the tooltip
        thisElement.after $compile(htmlTemplate)(scope)
        
        #get tooltip element
        theTooltip = element[0].nextSibling
        theTooltipElement = angular.element(theTooltip)

        theContent = element[0].nextSibling.getElementsByClassName("content")[0]

        scope.initTooltip = getInfos = (side) ->
          height = element[0].offsetHeight
          width = element[0].offsetWidth
          offsetTop = element[0].offsetTop
          offsetLeft = element[0].offsetLeft
          
          #get tooltip dimension
          theTooltipHeight = theTooltipElement[0].offsetHeight
          theTooltipWidth = theTooltipElement[0].offsetWidth
          scope.tooltipPositioning side
          return

        thisElement.on "mouseenter mouseover", () ->
          scope.showTooltip()
          return

        thisElement.on "mouseleave mouseout", () ->
          scope.hideTooltip()
          return

        thisElement.on "click contextmenu", () ->
          # Force This to Run *After* Controller Finishes Updating
          $timeout(() ->
            theContent.innerHTML = attr.tooltipContent
          )
          return

        scope.showTooltip = () ->
          theTooltip.classList.add "tooltip-open"
          $timeout(() ->
            theContent.innerHTML = attr.tooltipContent
          )
          return

        scope.hideTooltip = () ->
          theTooltip.classList.remove "tooltip-open"
          return

        scope.tooltipPositioning = tooltipPositioning = (side) ->
          topValue = undefined
          leftValue = undefined
          if size is "small"
            theTooltipMargin = TOOLTIP_SMALL_MARGIN
          else if size is "medium"
            theTooltipMargin = TOOLTIP_MEDIUM_MARGIN
          else theTooltipMargin = TOOLTIP_LARGE_MARGIN  if size is "large"
          if side is "left"
            topValue = offsetTop + height / 2 - theTooltipHeight / 2
            theTooltipElement.css "top", topValue + "px"
            theTooltipElement.css "left", offsetLeft + "px"
            theTooltipElement.css "margin-left", "-" + (theTooltipWidth + theTooltipMargin) + "px"
          if side is "right"
            topValue = offsetTop + height / 2 - theTooltipHeight / 2
            leftValue = offsetLeft + width + theTooltipMargin
            theTooltipElement.css "top", topValue + "px"
            theTooltipElement.css "left", leftValue + "px"
          if side is "top"
            topValue = offsetTop - theTooltipMargin - theTooltipHeight
            leftValue = offsetLeft + width / 2 - theTooltipWidth / 2
            theTooltipElement.css "top", topValue + "px"
            theTooltipElement.css "left", leftValue + "px"
          if side is "bottom"
            topValue = offsetTop + height + theTooltipMargin
            leftValue = offsetLeft + width / 2 - theTooltipWidth / 2
            theTooltipElement.css "top", topValue + "px"
            theTooltipElement.css "left", leftValue + "px"
          return

        scope.initTooltip side
        angular.element($window).bind "resize", onResize = ->
          scope.initTooltip side
          return

        return
    )
]