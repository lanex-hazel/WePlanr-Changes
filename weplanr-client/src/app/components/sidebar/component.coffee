Ctrl =($scope,Auth,$rootScope,$state)->

  $scope.user = Auth.getUser()
  $scope.uiState =
    showDropdown: false

  $scope.openDropdown = ->
    $scope.uiState.showDropdown = !$scope.uiState.showDropdown

  $scope.logout = ->
    localStorage.clear()
    $state.go("login",{reload: true})

angular.module('client').directive 'sidebar',->
  restrict: "E"
  replace: true
  templateUrl: 'app/components/sidebar/index.html'
  controller: Ctrl
