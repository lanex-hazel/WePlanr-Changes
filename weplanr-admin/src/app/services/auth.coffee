module = ($resource,Session)->
  user = null
  {
    getUser: ->
      return user
    setUser: (obj) ->
      user = obj
      return
    removeUser: ->
      user = null
      localStorage.removeItem("access_token")
      localStorage.removeItem("user_id")
      return

  }


angular.module('client').factory('Auth', module)
