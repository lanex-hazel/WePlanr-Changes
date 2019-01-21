Ctrl = ($scope,$state,Auth,growl,Session,User,MyVendor)->

  $scope.vendor = Session.get('currentVendor')
  $scope.goBack = -> window.history.back()

  $scope.$watch '$root.menuView', (val)->
    $scope.vendor = Session.get('currentVendor') if val


  if !Session.getAccessToken()
    Session.removeSession()
    $state.go('main.login')
  if Session.getAccessToken() && !!$scope.vendor
    Session.setHeaders() # ensure auth token is set
    User.profile().$promise
      .then (data) ->
        Session.set('currentUser', data.data.attributes)
        $scope.user = data.data.attributes
    MyVendor.getList().$promise
      .then (response)->
        Session.set('currentVendor', response.data[0].attributes)
        $scope.vendor = response.data[0].attributes
      .catch (err)->
        growl.error("Cannot fetch vendor.")

  $scope.logout = ->
    params =
      id: Session.getAccessToken()
    Session.logout(params).$promise
      .then (data) ->
        Auth.removeUser()
        Session.removeSession()
        olark('api.box.shrink')
        growl.success(MESSAGES.LOGOUT_SUCCESS)
        $state.go("main.intro")
      .catch (data)->
        growl.error('Unable to sign out.')

angular.module('client').controller('VendorCtrl', Ctrl)
