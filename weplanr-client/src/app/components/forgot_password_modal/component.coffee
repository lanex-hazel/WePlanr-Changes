Ctrl =($scope,$state,Session,Auth,growl,ModalService,User)->

  $scope.uiState =
    error: false
    loading: false

  $scope.inputEmail = ''
  $scope.email_sent = false

  $scope.forgot = ->
    $scope.uiState.loading =  true
    if ($scope.inputEmail && $scope.inputEmail.trim() != '')
      User.forgotPassword(email: $scope.inputEmail).$promise
        .then (data)->
          $scope.uiState.loading =  false
          $scope.email_sent = true
          $scope.inputEmail = null
        .catch (err)->
          $scope.uiState.loading =  false
          growl.error(err.data.error)
    else
      $scope.uiState.error = true
      $scope.uiState.loading =  false
    

angular.module('client').directive 'forgotPasswordModal',->
  restrict: "E"
  templateUrl: 'app/components/forgot_password_modal/index.html'
  controller: Ctrl