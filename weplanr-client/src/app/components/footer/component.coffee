Ctrl =($scope)->

  $scope.current_year = moment().year()

angular.module('client').directive 'footer',->
  restrict: "E"
  templateUrl: 'app/components/footer/index.html'
  controller: Ctrl
