module = ($resource,Session,User,$http)->
  user =
    attributes: null
  {
    getUser: ->
      return user.attributes
    setUser: (obj)->
      user = obj
      return
    removeUser: ->
      user = null
      localStorage.removeItem("access_token")
      return

  }


angular.module('client').factory('Auth', module)
