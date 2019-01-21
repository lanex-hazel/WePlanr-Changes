angular.module('client').run [
  '$rootScope','$location','$state','$window','$http','Session','Auth', 'BASE_ENDPOINT', ($rootScope,$location,$state,$window,$http,Session,Auth,BASE_ENDPOINT) ->

    img_endpoint = BASE_ENDPOINT.replace('/api', '')
    $rootScope.sanitize_url = (link)->
      if /^http/.test(link) then link else img_endpoint + link

    $rootScope.setPhoto = (link,isFave=false)->
      if !!link
        if /^http/.test(link) then link else img_endpoint + link
      else
        '/vendor/images/default_user.png'
    
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->

      unless (toState.name.includes("index") && fromState.name.includes("detail")) || (toState.name.includes("detail") && fromState.name.includes("index"))
        $rootScope.currentPage = 1
      
      console.log 'stateChangeStart', toState
      Session.setHeaders()
      if toState.unauthenticated
        if Session.getToken()
          event.preventDefault()
          $state.go('admin.dashboard')
        else
          console.log 'no auth needed'
      else
        if Session.getToken()
          console.log 'loaded AuthToken'
        else
          event.preventDefault()
          console.log 'redirected to login'
          $state.go('auth.login')

]
