Ctrl =($scope,Session)->

angular.module('client').directive 'burgerMenuVendor',->
  restrict: "E"
  templateUrl: 'app/components/burger_menu_vendor/index.html'
  controller: Ctrl