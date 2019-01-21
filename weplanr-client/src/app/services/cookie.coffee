module = ($cookies)->

  expireDate = new Date()
  expireDate.setDate(expireDate.getDate() + 1)
  {
    set: (key, val)->
      $cookies.put(key, JSON.stringify(val), {'expires': expireDate})
    get: (key)->
      if $cookies.get(key)?
        JSON.parse($cookies.get(key))
      else
        null
    remove: (key)->
      $cookies.remove(key)
  }

angular.module('client').factory('Cookie', module)
