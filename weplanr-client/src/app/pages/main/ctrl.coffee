Ctrl = ($scope,$rootScope,$state,$interval,growl,ModalService,Session,Auth,MyVendor)->
  $scope.currentUser = Session.get('currentUser')

  if $scope.currentUser?.is_vendor
    MyVendor.getList().$promise.then (response)->
      $scope.vendor = response.data[0].attributes

  $scope.authenticated = false
  $scope.logout = ->
    Session.logout(id: Session.getAccessToken()).$promise
      .then (data) ->
        Auth.removeUser()
        Session.removeSession()
        $rootScope.menuView = false
        $state.reload()
        growl.success(MESSAGES.LOGOUT_SUCCESS)

  $scope.openModal = (id)->
    ModalService.Open(id)

  $scope.return = ->
    window.history.back()

  $interval ( ->
    return if $state.current.name in ['main.vendor_register', 'main.vendor_landing']
    vendor_id = if $state.params.id? then $state.params.id else null
    q = if $state.params.q? then $state.params.q else null
    if Session.getAccessToken() == null &&  ModalService.CheckState('register-modal') == 0
      Session.setRegisterEvent({current_state: $state.current.name, vendor_id: vendor_id, keyword_search: q})
      ModalService.Open('register-modal')
    return
  ), 900000, 1

  
angular.module('client').controller('MainCtrl', Ctrl)
