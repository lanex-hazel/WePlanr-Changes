Ctrl =($scope,Session)->

angular.module('client').directive 'burgerMenuCustomer',->
  restrict: "E"
  templateUrl: 'app/components/burger_menu_customer/index.html'
  controller: Ctrl