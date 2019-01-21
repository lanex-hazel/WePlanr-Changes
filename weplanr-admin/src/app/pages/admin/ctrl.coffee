Ctrl = ($scope,$state,Session,growl,$window,Auth)->

  $scope.logout = ->
    params =
      id: Session.getToken()
    Session.logout(params).$promise
      .then (data) ->
        Session.removeSession()
        growl.success(MESSAGES.LOGOUT_SUCCESS)
        $state.go("auth.login")
      .catch (data)->
        growl.error('Unable to sign out.')


angular.module('client').controller('AdminCtrl', Ctrl)
