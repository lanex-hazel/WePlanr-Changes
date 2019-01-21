Ctrl =($scope,$rootScope,$state,Session,Auth,growl,ModalService,User,MyVendor,Cookie,Service)->

  $scope.uiState =
    loading: false

  $scope.creds =
    email: ''
    password: ''

  $scope.keepLogin = true

  $scope.login =(form)->
    form.$submitted = true
    $scope.uiState.loading = true
    if form.$valid
      Session.login(credentials: $scope.creds).$promise
        .then (response) ->
          Session.setSession(response.data.attributes.token)
          Service.getCategories()
          User.profile().$promise.then (user) ->
            $scope.uiState.loading = false
            ModalService.Close('login-modal')
            $scope.creds =
              email: ''
              password: ''
            if user.data.attributes.reset_password_token?
              ModalService.Open('reset-modal')
              Session.removeSession()
              Session.set('reset_token', user.data.attributes.reset_password_token)
            else
              Session.setVendor(user.data.attributes.is_vendor)
              Session.set('currentUser', user.data.attributes)
              Auth.setUser(user.data)
              $rootScope.welcome_modal = user.data.attributes.user_settings.remind_user
              growl.success(MESSAGES.LOGIN_SUCCESS)
              redirectUrl = Cookie.get('saveAttemptUrl') != '/'  && !!Cookie.get('saveAttemptUrl')
              if user.data.attributes.is_vendor
                MyVendor.get().$promise.then (vendor)->
                  Session.set('currentVendor', vendor.data[0].attributes)
                  olark('api.box.shrink')
                  if redirectUrl && !Cookie.get('access_user')
                    Session.redirectToAttemptedUrl()
                  else
                    Session.removeAttemptedUrl()
                    $state.go('vendor.dashboard')
                  $rootScope.setPreloader()
              else
                if redirectUrl && Cookie.get('access_user')
                  Session.redirectToAttemptedUrl()
                else
                  Session.removeAttemptedUrl()
                  $state.go('user.dashboard')
                $rootScope.setPreloader()
        .catch (err) ->
          $scope.uiState.loading = false
          growl.error(err.data.error)
    else
      $scope.uiState.loading = false
      if !!form.login_email.$viewValue
        form.login_email.$setPristine()
        form.login_email.$setUntouched()
        form.login_email.$error.invalidEmail = !form.login_email.$viewValue.match("[a-zA-Z0-9._%+-]+@[a-zA-z0-9.-]+\.[a-z]{2,3}")


angular.module('client').directive 'loginModal',->
  restrict: "E"
  templateUrl: 'app/components/login_modal/index.html'
  controller: Ctrl
