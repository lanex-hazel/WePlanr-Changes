Ctrl = ($scope,$state,Session,growl,$http,Auth)->

  $scope.uiState =
    loading: false

  $scope.login =(creds)->
    $scope.uiState.loading = true
    Session.login(credentials: creds).$promise
      .then (response) ->
        Session.setSession(response.data.attributes.token)
        growl.success(MESSAGES.LOGIN_SUCCESS)
        $state.go('admin.dashboard')
      .catch (response)->
        growl.error(MESSAGES.INVALID_CREDS)
      .finally ->
        $scope.uiState.loading = false


angular.module('client').controller('LoginCtrl', Ctrl)
