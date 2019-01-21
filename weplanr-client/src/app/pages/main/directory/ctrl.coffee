Ctrl = ($scope,$state,$location,growl,Session,Vendor,Service,Location)->

  $scope.loading = false
  $scope.query =
    q: ''
    locations: ''
  $scope.count = ''
  $scope.label_options =[
    {value: 'favorite', name: 'favourites'},
    {value: 'category', name: 'all categories'}
  ]
  $scope.locations = []
  $scope.locations.unshift {attributes: name: 'ALL LOCATION'}
  $scope.selected = $scope.label_options[1]
  $location.search('type', 1) unless !!$state.params.type

  $scope.filter_location = {attributes: name: 'ALL LOCATION'}
  $scope.fave_vendors = []
  $scope.searchList = []
  $scope.loaded =
    services: false
    locations: false
  $scope.listCategory = true

  Service.getList(category: true).$promise.then (res)->
    $scope.categories = res.data
    $scope.loaded.services = true

  if !!$state.params.services
    $scope.listCategory = false
    $scope.selected_service = $state.params.services
  else
    $scope.selected_service = ''

  Location.getList().$promise.then (res)->
    $scope.locations = res.data
    $scope.loaded.locations = true
    $scope.locations.unshift {attributes: name: 'ALL LOCATION'}
    if !!$state.params.locations
      $scope.listCategory = false
      idx = $scope.locations.findIndex((el) -> el.attributes.name == $state.params.locations)
      $scope.filter_location = $scope.locations[idx]
    else
      $scope.filter_location = $scope.locations[0]

  $scope.search = ->
    $scope.loading = true
    $scope.count = ''
    Vendor.query($scope.query).$promise.then (res) ->
      $scope.searchList = res.data
      $scope.loading = false

  $scope.searchCategory = ->
    $scope.loading = true
    $scope.count = ''
    Vendor.categorize(angular.extend($scope.query, group_by: 'service', limit: 100000)).$promise.then (res) ->
      $scope.vendors = res.data
      $scope.loading = false
    delete $scope.query.groupBy
    delete $scope.query.limit

  $scope.favorite = ->
    $scope.count = ''
    $scope.fave_vendors = Session.getFaveList() if !!Session.getFaveList()
    $scope.count = $scope.fave_vendors.length

  $scope.fave =(vendor)->
    $scope.fave_vendors.push Vendor.formatVendor(vendor)
    Session.setFaveVendors($scope.fave_vendors)
    swal(FAVOURITE_MSG)

  $scope.unfave =(vendor)->
    # swal(UNFAVE_WARNING).then (isConfirm) ->
    #   if isConfirm
    index = $scope.fave_vendors.findIndex((el) -> el.id == vendor.id)
    $scope.fave_vendors.splice index, 1
    Session.setFaveVendors($scope.fave_vendors)
    swal(UNFAVOURITE_MSG)

  $scope.$watch '[loaded.services, loaded.locations]', (values) ->
    params = angular.copy($state.params)
    delete params.services
    delete params.type
    $scope.query = params
    $scope.listCategory = false if !!$state.params.q || $state.params.type == '0'
    if values[0] && values[1]
      $scope.searchCategory()
      $scope.favorite()
      $scope.search() if $scope.selected.value == 'category' && !!$scope.selectedService == false

angular.module('client').controller('DirectoryCtrl', Ctrl)
