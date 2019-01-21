module = ($resource,BASE_ENDPOINT,$http,Cookie,$location,Analytics,FakeLocalStorage)->

  Session = $resource "#{BASE_ENDPOINT}", null,
    {
      login:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/auth_tokens"
      logout:
        method: 'DELETE'
        url: "#{BASE_ENDPOINT}/auth_tokens"
      register:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/register"
      vendor_register:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/register/vendor"
      confirmAccount:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/auth_tokens/confirm"
    }

  query = null
  wedding_details =
    date: ''
    location: ''
  favorites =
    vendor_ids: []
  evt =
    metadata_event: {current_state:'register', continue: false}

  angular.extend Session,
    setSession: (token)->
      #set cookie
      Session.set("access_token", token)
      Session.setHeaders()

    setVendor: (data) ->
      Session.set("vendor", data)

    getVendor: ->
      Session.get("vendor")

    setCachedCoordinates: (address, coords) ->
      localStorage.setItem(address, coords)

    getCachedCoordinates: (address) ->
      localStorage.getItem(address)

    removeSession: ->
      localStorage.clear()
      Cookie.remove('categories')
      $http.defaults.headers.common.Authorization = null

    setHeaders: ->
      $http.defaults.headers.common.Timezone ||= moment().format('Z')
      $http.defaults.headers.common.Authorization = "Token token=\"#{@getAccessToken()}\""
      # GA header
      return unless user = @get('currentUser')
      return if /^4DM1N/.test(@getAccessToken())
      Analytics.set('&uid', user.internal_id)
      Analytics.pageView()

    getAccessToken: ->
      Session.get('access_token')

    setWeddingInfo: (obj)->
      wedding_details = obj

    getWeddingInfo: ->
      return wedding_details

    setCurrentQuery: (obj)->
      query = obj

    getCurrentQuery: ->
      return query

    setFaveVendors: (list)->
      Session.set('myFavorites',{vendor_ids: list.map (obj)-> obj['id']})
      Session.set('myFaveList',list)

    getFaveVendors: ->
      return Session.get('myFavorites')

    getFaveList: ->
      return Session.get('myFaveList')

    removePrefavorite: ->
      Session.remove('myFavorites')
      Session.remove('myFaveList')

    setRegisterEvent: (obj)->
      evt.metadata_event = obj

    getRegisterEvent: ->
      return evt

    saveAttemptedUrl: (obj)->
      user = !!obj
      Cookie.set('access_user', user)
      if $location.path() != '/'
        Cookie.set('saveAttemptUrl', $location.$$url)
      else
        Cookie.set('saveAttemptUrl', '/')

    removeAttemptedUrl: ->
      Cookie.remove('saveAttemptUrl')

    redirectToAttemptedUrl: ->
      url =  Cookie.get('saveAttemptUrl')
      Cookie.remove('saveAttemptUrl')
      $location.url(url)

    set: (key, val)->
      if Session.isLocalStorage()
        if typeof val is "string"
          localStorage.setItem(key, val)
        else
          localStorage.setItem(key, JSON.stringify val)
      else
        FakeLocalStorage.set(key,val)
    get: (key)->
      if Session.isLocalStorage()
        try
          JSON.parse localStorage.getItem(key)
        catch e
          localStorage.getItem(key)
      else
        FakeLocalStorage.get(key)
    remove: (key)->
      if Session.isLocalStorage()
        localStorage.removeItem(key)
      else
        FakeLocalStorage.remove(key)

    isLocalStorage: ->
      try
        localStorage.setItem('testLocal','test')
        localStorage.getItem('testLocal')
        return true
      catch e
        return false

  Session

angular.module('client').factory('Session', module)
