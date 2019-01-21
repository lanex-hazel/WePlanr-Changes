Ctrl =($scope,$state,Session,Auth,growl,ModalService,User)->

  $scope.uiState =
    loading: false
    error: ''
  $scope.user =
    email: null
    password: null
    new_password: null
    confirm_password: null
  $scope.set_password = false


  $scope.reset =(form)->
    token =
      if !!$state.params.token
        $state.params.token
      else
        Session.get('reset_token')
    $scope.uiState.loading = true
    form.$submitted = true
    if form.$valid
      User.resetPassword(angular.extend($scope.user, {token: token})).$promise
      .then (data)->
        $scope.uiState.loading = false
        $scope.set_password = true
        Session.remove('reset_token')
      .catch (err)->
        $scope.uiState.loading = false
        $scope.set_password = false
        $scope.user.password = null
        $scope.user.new_password = null
        $scope.user.confirm_password = null
        $scope.resetForm.tempPassword.$setUntouched()
        $scope.resetForm.newPassword.$setUntouched()
        $scope.resetForm.confirmPassword.$setUntouched()
        $scope.uiState.error = err.data.error
        growl.error(err.data.error)
    else
      $scope.uiState.loading = false
      $scope.set_password = false
      growl.error(MESSAGES.FORM_ERROR)
    

angular.module('client').directive 'resetPasswordModal',->
  restrict: "E"
  templateUrl: 'app/components/reset_password_modal/index.html'
  controller: Ctrl