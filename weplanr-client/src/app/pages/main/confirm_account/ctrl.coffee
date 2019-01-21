Ctrl =($scope, $rootScope, $state, Cookie, Session, Auth, MyVendor) ->
  redirectUrl = Cookie.get('saveAttemptUrl') != '/'  && !!Cookie.get('saveAttemptUrl')
  Session.confirmAccount(confirmation_token: $state.params.token).$promise
    .then (response)->
      Session.setSession(response.data.attributes.auth_token)
      Session.setVendor(response.data.attributes.is_vendor)
      Session.set('currentUser', response.data.attributes)
      Auth.setUser(response.data)
      $rootScope.welcome_modal = response.data.attributes.user_settings.remind_user
      if response.data.attributes.is_vendor
        MyVendor.get().$promise.then (vendor)->
          Session.set('currentVendor', vendor.data[0].attributes)
          $state.go('vendor.dashboard')
      else
        $state.go('user.dashboard')
    .catch (err)->
      $state.go('main.intro')


angular.module('client').controller('ConfirmAcctCtrl', Ctrl)
