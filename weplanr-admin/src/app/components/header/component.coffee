Ctrl =($scope,Session,$rootScope)->

  $scope.loggedIn = ->
    Session.getToken()

angular.module('client').directive 'header',->
  restrict: "E"
  replace: true
  templateUrl: 'app/components/header/index.html'
  controller: Ctrl
  scope:
    logout: "&"
