angular.module("test", ["ng", "ngAnimate"])
.controller "Ctrl", ($scope, $animate) ->
	$scope.var1 = "hello world"
