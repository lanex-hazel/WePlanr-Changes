module = ($resource,BASE_ENDPOINT,$http)->

  Session = $resource "#{BASE_ENDPOINT}/admin/auth_tokens", null,
    {
      login:
        method: 'POST'
      logout:
        method: 'DELETE'
      loginAs:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/admin/login_as/:id"
        params:
          id: '@id'
    }


  Session.setSession =(token)->
    localStorage.setItem("auth_token", token)
    Session.setHeaders()
  
  Session.getToken = ->
    return localStorage.getItem("auth_token")

  Session.setHeaders = ->
    console.log 'token', @getToken()
    $http.defaults.headers.common.Authorization = "Token token=\"#{@getToken()}\""

  Session.removeSession = ->
    localStorage.removeItem("auth_token")

  Session

angular.module('client').factory('Session', module)
