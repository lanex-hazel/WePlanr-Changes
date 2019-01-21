angular.module('client').directive 'vendorSearch',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/search/partials/search_form.html'
angular.module('client').directive 'vendorResult',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/search/partials/search_result.html'