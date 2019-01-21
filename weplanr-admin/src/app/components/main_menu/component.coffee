angular.module('client').directive 'mainMenu',[
  '$state'
  ($state) ->
    restrict: "E"
    replace: true
    templateUrl: 'app/components/main_menu/index.html'
    link: (scope, element, attrs) ->
      scope.state = $state

]
