Ctrl = ($scope,$rootScope,growl,User,Vendor,Session,$stateParams,Service,Location,$location,$timeout)->

  $scope.faveVendors =[]
  $scope.services = []
  $scope.keywords = {}
  $scope.loc = []
  $scope.collection = []

  $scope.query =
    if !!$stateParams
      $stateParams
    else
      q: ''
      locations: ''
      services: ''
      date: ''

  $scope.page =
    number: 1
    size: 8

  $scope.uiState =
    keyword: ''
    loading: false
    processing: false
    loadMore: false
    scrollable: false
    count: 0
    totalPages: 0
    initial: !!$stateParams

  $scope.search =(params, new_search=true)->
    $timeout ->
      if $scope.uiState.scrollable && !new_search
        $scope.uiState.loadMore = true
        $scope.page.number++
      else
        $scope.collection = []
        $scope.uiState.loading = true
        $scope.uiState.loadMore = false
        $scope.uiState.initial = false
        $scope.uiState.scrollable = false
        $scope.page.number = 1
        if params
          $location.search(params)
        else
          $location.search('q','')
        # Session.set('curQuery',params)
      $scope.uiState.keyword = Object.keys(params).map((k) ->  params[k]).join(" ")
      Vendor.getlist(angular.extend($scope.page,params)).$promise
        .then (response)->
          $scope.collection = $scope.collection.concat(response.data)
          $scope.uiState.count = response.meta.record_count
          $scope.uiState.totalPages = Math.ceil(response.meta.record_count/8)
          $scope.uiState.loading = false
          $scope.uiState.loadMore = false
          $scope.uiState.scrollable = true if $scope.page.number < $scope.uiState.totalPages
          $scope.query.services = '' if $scope.searchTitle
        .finally ->
          $scope.uiState.loading = false
          $scope.uiState.loadMore = false
          # $location.search('q', params.q)

  $scope.favorite =(obj)->
    $scope.uiState.processing = true
    Vendor.favourite(id: obj.id).$promise
      .then (response)->
        $scope.getFaves()
        swal(FAVOURITE_MSG)
        $scope.uiState.processing = false
      .catch (response)->
        $scope.uiState.processing = false
        growl.error('Process failed.')

  $scope.unfavorite =(obj)->
    $scope.uiState.processing = true
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: obj.id).$promise
          .then (response)->
            $scope.getFaves()
            swal(UNFAVOURITE_MSG)
          .catch (response)->
            growl.error('Process failed.')
      $scope.uiState.processing = false

  $scope.getFaves = ->
    User.favorites().$promise
      .then (response)->
        $scope.faveVendors = response.data.map (obj)-> obj['id']
      .catch (err)->
        growl.error(MESSAGES.NO_DATA)

  $scope.getServices = ->
    Service.getList().$promise.then (res) -> $scope.services = res.data

  $scope.getLocations = ->
    Location.getList().$promise.then (res) -> $scope.loc = res.data

  $scope.getServices()
  $scope.getLocations()
  $scope.getFaves()
  $scope.search($scope.query) if !!$stateParams.q
  Session.set('curQuery',$stateParams)


  return

angular.module('client').controller('VendorSearchCtrl', Ctrl)
