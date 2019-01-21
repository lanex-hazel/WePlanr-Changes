module = ->

  fakeLocalStorage = {}
  storage = {}

  {
    set: (key, val)->
      storage[key] = if typeof val is "string" then val else JSON.stringify(val)
    get: (key)->
      try
        JSON.parse(storage[key])
      catch e
        storage[key]
    remove: (key)->
      delete storage[key]
    clear: ->
      storage = {}
  }

angular.module('client').factory('FakeLocalStorage', module)
