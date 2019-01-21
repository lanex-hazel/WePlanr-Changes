Ctrl = ($scope,$state,$rootScope,growl,Session,Vendor,MyVendor,LoadData,Location,ModalService,$timeout,User,Auth,$location,Cookie)->

  $scope.q = ''
  $scope.collection = []
  $scope.faveList =
    if !!Session.getFaveList()
      Session.getFaveList()
    else
      []
  $scope.years = LoadData.getYear()
  $scope.months = LoadData.getMonth()
  $scope.days = LoadData.getDay()
  $scope.location_label = "THAT'S ABSOLUTELY FINE!"
  $scope.locations = []

  Location.getList().$promise.then (res) ->
    $scope.locations = res.data.filter((obj) ->
      (obj.attributes.name.toLowerCase() != 'australia wide' && obj.attributes.name.toLowerCase() != 'international')
    )

  $scope.selected_date =
    day: ''
    month: ''
    year: ''

  $scope.details =
    date: ''
    location: ''

  $scope.uiState =
    loading: false
    step1: false
    step2: false
    step3: false
    currentCard: 'start'

  $timeout ->
    if Cookie.get('saveAttemptUrl') != '/index' && !!Cookie.get('saveAttemptUrl')
      ModalService.Open('login-modal')

  $scope.start =(answer)->
    $scope.details.hasVenue = not answer
    $scope.uiState.currentCard = if answer then 'card1' else 'card2'

  $scope.changeCard =(val,card)->
    if val? && val != ''
      switch card
        when 'q1' then $scope.uiState.step1 = true
        when 'q2' then $scope.uiState.currentCard = 'card3'
        when 'q3'
          $scope.details.location = val
          $scope.uiState.step3 = true
    else
      switch card
        when 'q1' then $scope.uiState.step1 = false
        when 'q2' then $scope.uiState.currentCard = 'card3'
        when 'q3' then $scope.uiState.step3 = false

    Session.setWeddingInfo($scope.details)

  $scope.enterCard =(val,card)->
    if val? && val != ''
      if card == 'q2'
        $scope.uiState.currentCard = 'card3'
      else
        $state.go("main.search", {q: val, redirect: true})
    else
      switch card
        when 'q1' then $scope.openModal('register-modal')
        when 'q2' then $scope.uiState.currentCard = 'card3'
        when 'q3' then $scope.suggest()

  $scope.setDate =(obj)->
    $scope.uiState.step2 = false
    $scope.days = LoadData.getDay(moment("".concat(obj.year,"-",obj.month)).daysInMonth()) if obj?.year && obj?.month
    obj.day = '' if parseInt(obj.day) > $scope.days.length && obj?.day
    if obj?.year && obj?.month && obj?.day
      $scope.details.date = "".concat(obj.year,"-",obj.month,"-",obj.day)
      $scope.uiState.step2 = true
      $scope.location_label = "AWESOME!"

  $scope.suggest = ->
    $location.search('favourites', true)
    $timeout ->
      document.body.scrollTop = 1300
    $scope.uiState.currentCard = 'suggest'
    $scope.uiState.loading = true
    params = group_by: 'location'
    params.services = 'Reception Ceremony'
    Vendor.categorize(params).$promise
      .then (response)->
        $scope.collection = response.data
        $scope.uiState.loading = false
      .finally ->
        $scope.uiState.loading = false

  $scope.favorite =(vendor)->
    $scope.faveList.push Vendor.formatVendor(vendor)
    Session.setFaveVendors($scope.faveList)
    swal(FAVOURITE_MSG)

  $scope.unfavorite =(vendor)->
    # swal(UNFAVE_WARNING).then (isConfirm) ->
    #   if isConfirm
    index = $scope.isFave(vendor)
    $scope.faveList.splice index, 1
    Session.setFaveVendors($scope.faveList)
    swal(UNFAVOURITE_MSG)

  $scope.isFave =(vendor)->
    $scope.faveList.findIndex((el) -> el.id == vendor.id)

  $scope.openModal =(id, type)->
    ModalService.Open(id, type)

  $scope.fetchServices =(obj)->
    Vendor.allServices(obj)

  $timeout(->
    if $state.params.login
      $scope.openModal('login-modal')
    if $state.params.signup
      $scope.openModal('register-modal')
    if $state.params.start
      elem = document.getElementById('inquiry')
      window.scrollTo(elem.offsetLeft, elem.offsetTop)
      $scope.start($state.params.start is 'yes')

    if $state.params.atoken && $state.params.atoken.trim() isnt ''
      token = atob($state.params.atoken)
      #Session.removeSession()
      Session.setSession(token)
      User.profile().$promise.then (response) ->
        growl.success("Logged in as #{response.data.attributes.email}")
        Session.set('currentUser', response.data.attributes)
        Auth.setUser(response.data)
        isVendor = response.data.attributes.is_vendor
        Session.setVendor(isVendor)
        if isVendor
          MyVendor.get().$promise.then (vendor)->
            Session.set('currentVendor', vendor.data[0].attributes)
            $state.go('vendor.dashboard')
        else
          $state.go('user.dashboard')


    if $state.params.reset_password &&  $state.params.token.trim() != ''
      User.verifyResetToken(token: $state.params.token).$promise
        .then (response)->
          $scope.openModal('reset-modal')
        .catch (err)->
          growl.error(err.data.error)

    if $state.params.t and $state.params.t.trim() isnt ''
      Vendor.verifyInviteToken(token: $state.params.t).$promise.then (response)->
        $rootScope.invitedEmail  = response.email
        $scope.openModal('invited-vendor-register-modal')
      , ->
        ModalService.Open('login-modal')
  , 100)

  $scope.scroll =(evt,isLeft)->
    elem = angular.element(evt.target).closest('.search-results')
    move = 253
    if isLeft
      elem.animate({ scrollLeft: '+='+move}, 500)
    else
      elem.animate({ scrollLeft: '-='+move}, 500)

  if $state.params.favourites
    $scope.suggest()

angular.module('client').controller('IntroCtrl', Ctrl)
