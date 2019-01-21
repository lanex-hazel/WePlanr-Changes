Ctrl = ($scope,$state,$filter,$rootScope,$timeout,Auth,growl,User,Vendor,Organisr,Todo,Wedding,$window,Session)->

  $scope.currentUser = Session.get('currentUser')
  $scope.wedding_date = User.wedding_date(moment().format('YYYY-MM-DD'))
  $scope.cur_wedding_date = $scope.currentUser.wedding_details.date
  $scope.wedding_date = User.wedding_date($scope.cur_wedding_date) if !!$scope.cur_wedding_date

  $scope.totalPlanned = 0
  $scope.totalSpend = 0
  $scope.totalDifference = 0
  Organisr.query().$promise.then (res)->
    #budget
    for obj in res.data
      $scope.totalPlanned += Number(obj.attributes.planned)
      $scope.totalSpend += parseInt(obj.attributes.paid)
    $scope.totalDifference = $scope.totalPlanned - $scope.totalSpend
    #todo
    Todo.dashboard().$promise.then (res)->
      $scope.todos = res.data

  $scope.mod = 0
  $scope.display_copy = ''
  currentOutstandingTodo = ->
    role = if $scope.currentUser.role? then $scope.currentUser.role else 'bride'
    if $scope.currentUser.outstanding_todo?
      $scope.mod = $scope.currentUser.outstanding_todo.views % 3
      switch $scope.mod
        when 1 then $scope.display_copy = $scope.currentUser.outstanding_todo.suggestion_copy[role]
        when 2 then $scope.display_copy = $scope.currentUser.outstanding_todo.reminder_copy
        else $scope.display_copy = $scope.currentUser.outstanding_todo.question_copy
  currentOutstandingTodo()

  $scope.personalise_question = ''
  User.profile().$promise.then (res)->
    personalise = res.data.attributes
    $scope.currentUser.user_settings = res.data.attributes.user_settings
    $scope.currentUser.outstanding_todo = res.data.attributes.outstanding_todo
    currentOutstandingTodo()
    Session.set('currentUser',res.data.attributes)
    if !personalise.partner
      $scope.personalise_question = DASHBOARD_CARD.PARTNER
    else if !personalise.wedding_details.date
      $scope.personalise_question = DASHBOARD_CARD.DATE
    else if !personalise.wedding_details.location
      $scope.personalise_question = DASHBOARD_CARD.LOCATION
    else if !personalise.wedding_details.budget
      $scope.personalise_question = DASHBOARD_CARD.BUDGET

  $scope.loading = false
  $scope.processing = false
  $scope.collection = []
  $scope.fave_vendors = []
  $scope.faveList = []
  $scope.editEnable =
    date: false
    location: false
    partner: false
  $scope.page =
    number: 1
    size: 4

  $scope.favorite =(obj)->
    $scope.processing = true
    Vendor.favourite(id: obj.id).$promise
      .then (response)->
        $scope.fave_list($scope.page)
        swal(FAVOURITE_MSG)
        $scope.processing = false
      .catch (response)->
        growl.error('Process failed.')
        $scope.processing = false

  $scope.unfavorite =(obj)->
    $scope.processing = true
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: obj.id).$promise
          .then (response)->
            $scope.fave_list($scope.page)
            swal(UNFAVOURITE_MSG)
            $scope.processing = false
          .catch (response)->
            $scope.processing = false
            growl.error('Process failed.')

  $scope.fave_list =(page)->
    $scope.loading = true
    User.favorites().$promise
      .then (response)->
        $scope.fave_vendors = response.data
        $scope.faveList = response.data.map (obj)-> obj['id']
      .finally ->
        $scope.loading = false

  $scope.isFave =(vendor_id)->
    $scope.faveList.indexOf(vendor_id) if $scope.faveList.length > 0

  $scope.vendors_togo_list = ->
    $scope.loading = true
    if $scope.currentUser.outstanding_todo?
      Vendor.featured(number: 1, size: 4).$promise
        .then (response)->
          $scope.collection = response.data
        .finally ->
          $scope.loading = false
    else
      Vendor.query(number: 1, size: 4).$promise
        .then (response) ->
          $scope.collection = response.data
        .finally ->
          $scope.loading = false

  $scope.searchWithTodo = ->
    todo = $scope.currentUser.outstanding_todo
    if $scope.mod == 2
      $scope.mod = 0
      $scope.display_copy = $scope.currentUser.outstanding_todo.question_copy
    else
      $rootScope.baseSearch =
        q: todo.name
        date:  moment().format('DD/MM/YY')
        title: todo.redirect_copy
      $state.go('user.search')

  $scope.personaliseDashboard = ->
    $rootScope.welcome_modal= false

  $scope.customNo = ->
    params =
      attributes: metadata_event:
        current_state: $scope.currentUser.user_settings.state
        vendor_id: $scope.currentUser.user_settings.pending_enquiry
        keyword_search: $scope.currentUser.user_settings.keyword_search
        continue: true
    User.update(data: params).$promise.then (response)->
      Auth.setUser(response.data.attributes)
      Session.set('currentUser',response.data.attributes)
      $scope.currentUser = response.data.attributes

  $scope.updateCard =(answer)->
    prevSettings = $scope.currentUser.user_settings
    params =
      attributes: metadata_event: {current_state: 'todo'}
    User.update(data: params).$promise.then (response)->
      Auth.setUser(response.data.attributes)
      Session.set('currentUser',response.data.attributes)
      $scope.currentUser = response.data.attributes
      if answer && (prevSettings.state == 'enquiry' || prevSettings.state == 'main.vendorprofile')
        $state.go('user.vendor.show', {id: prevSettings.pending_enquiry})
      else if answer && prevSettings.state == 'main.search'
        $state.go('user.search', {q: prevSettings.keyword_search, search: true})
    .catch (err)->
      console.error "Error:", err

  $scope.scroll =(evt,isLeft)->
    elem = angular.element(evt.target).closest('.searched-results')
    move = 253
    if isLeft
      elem.animate({ scrollLeft: '+='+move}, 500)
    else
      elem.animate({ scrollLeft: '-='+move}, 500)

  $scope.redirect =(vendorId)->
    $rootScope.goBackTo = 'favourites'
    $state.go('user.vendor.show',{'id':vendorId})

  $scope.fetchServices =(obj)->
    Vendor.allServices(obj)

  $scope.vendors_togo_list()
  $scope.fave_list($scope.page)

angular.module('client').controller('DashboardCtrl', Ctrl)
