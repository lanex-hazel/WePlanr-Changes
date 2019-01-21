Ctrl =($scope,$state,growl,ModalService,Vendor)->

  $scope.uiState = loading: no
  $scope.password =  null
  $scope.confirmPassword = null

  confirmPassword = document.getElementById('confirm-password')
  $scope.validatePassword = ->
    if $scope.password isnt $scope.confirmPassword
      confirmPassword.setCustomValidity 'Passwords Don\'t Match'
    else
      confirmPassword.setCustomValidity ''

  $scope.submit = ->
    $scope.uiState.loading = yes
    params =
      data: attributes: password: $scope.password
      token: $state.params.t
    Vendor.registerViaInvite(params).$promise
      .then (data)->
        ModalService.Close('invited-vendor-register-modal')
        ModalService.Open('thanks-modal')
      .finally (err)->
        $scope.uiState.loading = no

  $scope.closeThanksModal = ->
    ModalService.Close('thanks-modal')

angular.module('client').directive 'invitedVendorRegisterModal',->
  restrict: 'E'
  templateUrl: 'app/components/invited_vendor_register_modal/index.html'
  controller: Ctrl
