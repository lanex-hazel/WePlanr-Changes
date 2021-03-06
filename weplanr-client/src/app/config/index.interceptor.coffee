angular.module('client').factory('httpInterceptor', [
  '$q','$rootScope','$injector','growl'
  ($q, $rootScope,$injector,growl) ->
    {
      responseError: (response) ->
        return if response.status not in [401,402,403,422,500]
        title = response.data.message or 'Oops!'
        message = response.data.error or response.data.errors?.join("<br><br>") or 'Something went wrong'
        switch response.status
          when 401,403
            growl.error(MESSAGES.ACCESS_DENIED)
            $injector.get('Auth').removeUser()
            $injector.get('Session').removeSession()
            $injector.get('$state').go("main.intro")
          when 402,422
            growl.error(message)
          when 500
            growl.error(MESSAGES.INTERNAL_SERVER_ERROR)
        $q.reject(response)
    }

]).config [
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.interceptors.push('httpInterceptor')
]
