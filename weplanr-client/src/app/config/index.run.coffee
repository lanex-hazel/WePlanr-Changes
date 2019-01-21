angular.module('client').run [
  '$rootScope','$location','$state','$window','$http','$filter','$timeout','$sce', 'Session','User','Auth','BASE_ENDPOINT','Feature','Analytics',
  ($rootScope,$location,$state,$window,$http,$filter,$timeout,$sce,Session,User,Auth,BASE_ENDPOINT,Feature,Analytics) ->

    $rootScope.setPreloader = ->
      $rootScope.preloader =
        show: on
        autoStop: yes

      $timeout(->
        if $rootScope.preloader.autoStop
          $rootScope.preloader.show = no
      , 4000)

    $rootScope.setPreloader()


    img_endpoint = BASE_ENDPOINT.replace('api', '')
    $rootScope.setBGImage = (link)->
      if link.length > 0
        if /^http/.test(link[0].url) then $sce.trustAsResourceUrl(link[0].url) else $sce.trustAsResourceUrl(img_endpoint + link[0].url)
      else
        DEFAULT_PHOTO

    $rootScope.setPhoto = (link)->
      if !!link
        if /^http/.test(link) then $sce.trustAsResourceUrl(link) else $sce.trustAsResourceUrl(img_endpoint + link)
      else
        DEFAULT_PHOTO

    $rootScope.referralState =
      customer: false
      vendor: false

    $rootScope.rewardState =
      customer: false

    ##Fetch backend state status
    Feature.query(id: 1).$promise.then (res)->
      $rootScope.referralState.customer = true if res.data.attributes.status == 1

    Feature.query(id: 2).$promise.then (res)->
      $rootScope.referralState.vendor = true if res.data.attributes.status == 1

    Feature.query(id: 3).$promise.then (res)->
      $rootScope.rewardState.customer = true if res.data.attributes.status == 1

    $rootScope.$on '$stateChangeSuccess', (event, currentState, prevState) ->
      stateName = currentState.backTitle or currentState.name.replace('main.', '').replace(/[-_]/g, ' ')
      $rootScope.pageTitle =
        switch stateName
          when 'our favourites' then null
          when 'vendorprofile' then 'Vendor Profile'
          else $filter('capitalizeAll')(stateName).replace(/\./g, ' ')
      $window.scrollTo(0, 0)

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if toState.name == 'main.vendor_landing' || toState.name == 'main.vendor_register'
        $rootScope.isVendor = true
        $rootScope.isCustomer= false
      else
        $rootScope.isVendor = false
        $rootScope.isCustomer= true

      ## variable title for back link
      if fromState.backTitle == 'profile' && $rootScope.goBackto != ''
        $rootScope.goBackTo = 'search results'
      else if !!fromState.name
        $rootScope.goBackTo = fromState.backTitle
      if (!fromState.name && toState.backTitle == 'profile') || !!Session.get('backTitle') && !$rootScope.goBackTo
        $rootScope.goBackTo = Session.get('backTitle')
      Session.set('backTitle', $rootScope.goBackTo) if !$rootScope.goBackTo || $rootScope.goBackTo != 'undefined'

      ## remove welcome popup modal
      ## when redirect to other pages
      if toState.name != 'user.dashboard' && toState.name != "main.confirm_account" && toState.name != "vendor.dashboard"
        $rootScope.welcome_modal = false

      ## show search page sets white bg
      if toState.name.includes('search')
        $rootScope.searchWrapper = true
        $rootScope.menuView = false
      else
        $rootScope.searchWrapper = false

      Session.setHeaders()

      window.firebaseUnwatchers ?= []
      unwatcher() for unwatcher in window.firebaseUnwatchers
      window.firebaseUnwatchers = []

      if toState.public
      else if toState.unauthenticated
        if $location.search()['atoken'] && $location.search()['atoken'] isnt ''
          Session.removeSession()

        if !!Session.getAccessToken()
          event.preventDefault()
          if Session.getVendor()
            return $state.go('vendor.dashboard')
          else
            return $state.go('user.dashboard')
        else
          return
      else
        if !!Session.getAccessToken() && Session.getVendor() && toState.auth_vendor
          return
        else if !!Session.getAccessToken() && !Session.getVendor() && toState.auth_user
          return
        else
          Session.saveAttemptedUrl(toState.auth_user)
          event.preventDefault()
          Session.removeSession()
          return $state.go('main.intro')
      return

]
