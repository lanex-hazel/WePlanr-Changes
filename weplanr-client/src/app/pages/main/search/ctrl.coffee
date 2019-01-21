Ctrl = ($scope,$state,$rootScope,$location,growl,Vendor,Session,$stateParams,Service,Location,$timeout)->

  $scope.collection = []
  $scope.services = []
  $scope.keywords = {}
  $scope.loc = []
  $scope.toggle = false
  $scope.faveList =
    if !!Session.getFaveList()
      Session.getFaveList()
    else
      []

  $scope.query =
    if !!$stateParams
      q: $stateParams.q
      locations: $stateParams.locations
      services: $stateParams.services
      date: $stateParams.date
    else
      q: ''
      locations: ''
      services: ''
      date: ''

  $scope.page =
    number: 1
    size:8

  $scope.uiState =
    keyword: ''
    loading: false
    loadMore: false
    scrollable: false
    count: 0
    totalPages: 0
    form: true
    initial: !!$stateParams

  $scope.header_params =
    search: {}

  $scope.searchToggle =(val)->
    $scope.toggle = !val

  $scope.reset = ->
    $scope.query.services = ''
    $scope.query.date = ''
    $scope.query.locations = ''
    $scope.keywords = {}
    $scope.collection = []
    $scope.search($scope.query)

  $scope.selectService = (item,model) ->
    $scope.keywords.services = item.attributes.name
    $scope.collection = []
    $scope.search($scope.query)

  $scope.search =(params, new_search=true)->
    $timeout ->
      if $scope.uiState.scrollable && !new_search
        $scope.uiState.loadMore = true
      else
        $scope.collection = []
        $scope.uiState.loading = true
        $scope.uiState.loadMore = false
        $scope.uiState.initial = false
        $scope.uiState.scrollable = false
        $scope.page.number = 1
        $('.hide-desktop').scrollLeft(0)
        if params
          $location.search(params)
        else
          $location.search('q','')
        # Session.set('curQuery',params)
      delete params.search
      $scope.uiState.keyword = Object.keys(params).map((k) ->  params[k]).join(" ")
      Vendor.getlist(angular.extend($scope.page,params)).$promise
        .then (response)->
          $scope.collection = $scope.collection.concat(response.data)
          $scope.uiState.count = response.meta.record_count
          $scope.uiState.totalPages = Math.ceil(response.meta.record_count/8)
          $scope.uiState.loading = false
          $scope.uiState.loadMore = false
          $scope.uiState.scrollable = true if $scope.page.number < $scope.uiState.totalPages
          $state.params = $scope.query
          angular.copy($state.params, $stateParams)
        .finally ->
          $scope.uiState.loading = false
          $scope.uiState.loadMore = false
      # $location.search(params)

  $scope.loadMore = ->
    if $scope.page.number < $scope.uiState.totalPages && !$scope.uiState.loading
      $scope.page.number++
      $scope.uiState.scrollable = true
      $scope.search($scope.query,false)
    else
      $scope.uiState.scrollable = false

  $scope.getServices = ->
    Service.getList().$promise.then (res) -> $scope.services = res.data

  $scope.getLocations = ->
    Location.getList().$promise.then (res) -> $scope.loc = res.data

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

  $scope.scroll =(evt,isLeft)->
    elem = angular.element(evt.target).closest('.hide-desktop')
    move = 0
    if isLeft
      if evt.currentTarget.offsetLeft > elem.scrollLeft() + move
        $scope.loadMore()
        move = evt.currentTarget.offsetLeft - elem.scrollLeft()
        elem.animate({ scrollLeft: '+='+ move}, 500)
      else
        elem.animate({ scrollLeft: '+=253'}, 500)
    else
      elem.animate({ scrollLeft: '-=253'}, 500)

  $scope.fetchServices =(obj)->
    Vendor.allServices(obj)

  $scope.getServices()
  $scope.getLocations()
  if $stateParams.search
    $scope.search($scope.query)
  else if $stateParams.redirect
    $scope.search($scope.query)
    $scope.uiState.form = false
    $stateParams.search = true
    delete $stateParams.redirect
    $scope.header_params.search = $stateParams
  else if !!$stateParams.q or $stateParams.locations or $stateParams.services or $stateParams.date
    $scope.search($scope.query)
  Session.set('curQuery',$stateParams)


  return

angular.module('client').controller('SearchCtrl', Ctrl)
