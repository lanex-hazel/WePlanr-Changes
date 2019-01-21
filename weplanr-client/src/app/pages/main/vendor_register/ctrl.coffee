Ctrl = ($scope,$state,growl,$stateParams,Session,Auth,Service,ModalService,$timeout)->
  currentYear = new Date().getFullYear()
  $scope.yearOptions = [currentYear]
  $scope.yearOptions.push(currentYear + num) for num in [1..5]
  $scope.connected = !!$state.params.code

  $scope.params =
    services: []
    tags: []
  $scope.tag_list = []
  $scope.uiState =
    loading: no
  $scope.group_categories = []
  $scope.error =
    services: false
  Service.categories().$promise.then (res) ->
    $scope.group_categories = res.data

  confirm_password = document.getElementById('repeat_password')
  $scope.$watch 'params.services', (val) ->
    if val.length != 0 && Number($scope.params.primary_service_id) != 14
      $scope.error.services = false
  $scope.validatePassword = ->
    if $scope.params.password isnt $scope.params.repeat_password
      confirm_password.setCustomValidity 'Passwords Don\'t Match'
    else
      confirm_password.setCustomValidity ''

  $scope.submit = ->
    $scope.uiState.loading = yes
    $scope.params.full_name = $scope.params.firstname + ' ' + $scope.params.lastname
    $scope.params.tags.push(tag.text) for tag in $scope.tag_list
    if $scope.params.services.length == 0 && Number($scope.params.primary_service_id) != 14
      $scope.error.services = true
    else
      $scope.error.services = false

    unless $scope.error.services
      Session.vendor_register(data: attributes: angular.extend($scope.params,Session.getFaveVendors())).$promise
        .then (response)->
          Session.removePrefavorite()
          ModalService.Open('check-email-modal')
        .finally ->
          $scope.uiState.loading = no
          Session.set('vendorRegistration', {})
        .catch (response)->
          $scope.uiState.loading = no
          console.error(response)
    else
      $scope.uiState.loading = no

  $scope.resetServices = ->
    $scope.selected_category = $scope.group_categories.filter (obj,idx, arr)->
      obj.id == Number($scope.params.primary_service_id)
    $scope.params.services = []
    $scope.error.services = false if Number($scope.params.primary_service_id) == 14

  $scope.closeModal = ->
    ModalService.Close('check-email-modal')
    $state.go('main.intro')

angular.module('client').controller('VendorRegisterCtrl', Ctrl)
