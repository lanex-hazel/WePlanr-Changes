Ctrl = ($scope,$rootScope,$state,Session,growl,Auth,User)->

  $scope.currentUser = Session.get('currentUser')
  $scope.$watch '$root.menuView', (val)->
    $scope.currentUser = Session.get('currentUser') if val

  $scope.goBack = -> window.history.back()
  $scope.goToDashboard = -> $state.go 'user.dashboard'

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


  return

angular.module('client').controller('UserCtrl', Ctrl)
