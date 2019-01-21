Ctrl =($scope,Auth,$window,$rootScope,Session,$state,Vendor,ModalService)->

  $scope.page=
    number: 1
    size: 20
  $scope.toggle = false
  $scope.showState =
    loading: false
    currentProfile: !!$state.params.id
  $rootScope.menuView = !!$state.params.menu
  $scope.isVendor = Session.getVendor()
  dropdown = false

  $scope.loggedIn = ->
    Session.getAccessToken()

  $scope.menuToggle =(val)->
    $rootScope.menuView = val

  $scope.openModal =(id)->
    ModalService.Open(id)

  $scope.toggleDropdown = ->
    dropdown = !dropdown
    if dropdown
      $('.dropdown').show()
    else
      $('.dropdown').hide()

  $scope.goBack = ->
    window.history.back()

  $scope.userInfo = ->
    if $scope.currentUser?.partner
      $scope.cachedName = $scope.currentUser.firstname + ' and ' + $scope.currentUser.partner.firstname + '&nbsp'
    else
      'Bride and Groom &nbsp;'

angular.module('client').directive 'header',->
  restrict: "E"
  templateUrl: 'app/components/header/index.html'
  controller: Ctrl
  scope:
    logout: "&"
    currentUser: "="
    currentVendor: "="
    params: "="
    pageTitle: "@?"
    searchUrl: "@"
