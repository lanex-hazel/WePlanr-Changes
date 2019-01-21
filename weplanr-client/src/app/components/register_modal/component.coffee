Ctrl =($rootScope,$scope,$stateParams,$state,Session,Auth,growl,ModalService)->

  $scope.form =
    firstname: ''
    lastname: ''
    email: ''
    phone: ''
    password: ''
  $scope.uiState =
    loading: false
    generic: false
    registered: false
    pattern: true
    phonePattern: true
    error: false

  $scope.$watch '$root.regType', (value) ->
    switch value
      when 'signupa'
        $scope.uiState.generic = false
        $scope.heading = "So we can help you better"
      when 'signupb'
        $scope.uiState.generic = false
        $scope.heading = "So we can help you keep track of everything and guide you every step of the way"
      else
        $scope.uiState.generic = true
        $scope.heading = "Plan your wedding effortlessly, <br>organise everything beautifully"
    $scope.uiState.registered = false

  $scope.registerCustomer=(form)->
    $scope.uiState.loading = true
    params =
      attributes: angular.extend($scope.form, Session.getWeddingInfo(), Session.getRegisterEvent(), Session.getFaveVendors())
    form.$submitted = true
    if form.$valid
      Session.register(data: params).$promise
        .then (response)->
          $scope.uiState.loading = false
          $scope.uiState.registered = true
          Session.removePrefavorite()
        .catch (response)->
          $scope.uiState.loading = false
          $scope.uiState.registered = false
          $scope.form.password = null
          $scope.form.repeat_password = null
          form.email.$error.invalidEmail = response.data.errors[0]
          $scope.registerForm.email.$setPristine()
          $scope.registerForm.password.$setUntouched()
          $scope.apply
          growl.error(MESSAGES.DUPLICATE_EMAIL_ERROR)
          $scope.uiState.error = false
    else
      $scope.uiState.loading = false
      $scope.uiState.registered = false
      $scope.uiState.error = true
      $scope.registerForm.firstname.$setTouched()
      $scope.registerForm.lastname.$setTouched()
      $scope.registerForm.email.$setTouched()
      $scope.registerForm.phone.$setTouched()
      $scope.registerForm.password.$setTouched()
      growl.error(MESSAGES.FORM_ERROR)

  $scope.favorite =(id)->
    Vendor.favourite(id: id).$promise
      .then (response)->
        console.log id, 'success'
      .catch (response)->
        console.error id, 'Process failed'

  $scope.redirect =(from, to)->
    $scope.uiState.registered = false
    ModalService.Close(from)
    ModalService.Open(to)

  $scope.close =(id)->
    $scope.uiState.registered = false
    ModalService.Close(id)


angular.module('client').directive 'registerModal',->
  restrict: "E"
  templateUrl: 'app/components/register_modal/index.html'
  controller: Ctrl
