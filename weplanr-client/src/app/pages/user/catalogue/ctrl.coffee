Ctrl = ($scope,$state,$location,growl,Session,Service,Location,Vendor,User)->
  $scope.currentUser = Session.get('currentUser')
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
  $scope.selected = $scope.label_options[Number($state.params.type)] if !!$state.params.type
  $scope.filter_location = {attributes: name: 'ALL LOCATION'}
  $scope.filter_service = false
  $scope.selectedService = ''
  $scope.searchList = []
  $scope.loaded =
    services: false
    locations: false
  $scope.list_category = true
  $scope.showCategory = true

  initial = true

  Service.getList(category: true).$promise.then (res)->
    $scope.categories = res.data
    $scope.loaded.services = true

  if !!$state.params.services
    $scope.list_category = false
    $scope.selectedService = $state.params.services
    # else
    #   $scope.selectedService = res.data[0].attributes.name

  Location.getList().$promise.then (res)->
    $scope.locations = res.data
    $scope.loaded.locations = true
    $scope.locations.unshift {attributes: name: 'ALL LOCATION'}
    if !!$state.params.locations
      $scope.list_category = false
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
    $location.search(angular.extend({'type': 1, 'services':$scope.selectedService},$scope.query)) unless initial

  $scope.favorite =(isInitial=false)->
    $scope.loading = true unless initial
    $scope.count = ''
    User.favorites($scope.query).$promise
      .then (response)->
        $scope.fave_vendors = response.data
        $scope.count = response.meta.record_count if !isInitial
        $scope.faveList = response.data.map (obj)-> obj['id']
        $scope.loading = false unless initial
    $location.search(angular.extend({'type': 0, 'services':$scope.selectedService},$scope.query)) unless initial

  $scope.showList =(showCategory=false)->
    initial = false
    delete $scope.query.type
    delete $scope.query.services
    if !showCategory
      $scope.list_category = false
    else
      $scope.list_category = true
      $location.search('type', 1)
    if $scope.selected.value == 'category' && !!$scope.selectedService == false && !showCategory
      $scope.search()
      $location.search(angular.extend({'type': 1},$scope.query))
    else if $scope.selected.value == 'category' && $scope.selectedService != ''
      @.searchCategory()
      $location.search(angular.extend({'type': 1, 'services':$scope.selectedService},$scope.query))
    else if $scope.selected.value == 'favorite'
      $scope.favorite()
      $location.search(angular.extend({'type': 0, 'services':$scope.selectedService},$scope.query))

  $scope.filterLocation =(item)->
    $scope.filter_location = item
    if item.attributes.name == 'ALL LOCATION'
      $scope.query.locations = ''
    else
      $scope.query.locations = $scope.filter_location.attributes.name
    $scope.showList()

  $scope.changeCategory =(item)->
    $scope.selected = item
    isCategory = $scope.selected.value == 'category'
    if isCategory
      $scope.selectedService = ''
      $scope.searchList = []
    $scope.showList(isCategory)

  $scope.setService =(service)->
    $scope.selectedService = service
    $scope.filter_service = true
    $scope.showList()

  $scope.fave_vendor =(obj)->
    $scope.processing = true
    Vendor.favourite(id: obj.id).$promise
      .then (response)->
        $scope.favorite($scope.page)
        swal(FAVOURITE_MSG)
        $scope.processing = false
        $scope.faveList.push obj.id
      .catch (response)->
        growl.error('Process failed.')
        $scope.processing = false

  $scope.unfave_vendor =(obj)->
    $scope.processing = true
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: obj.id).$promise
          .then (response)->
            $scope.favorite($scope.page)
            swal(UNFAVOURITE_MSG)
            $scope.processing = false
          .catch (response)->
            $scope.processing = false
            growl.error('Process failed.')

  $scope.isFave =(vendor_id)->
    $scope.faveList.indexOf(vendor_id) if $scope.faveList.length > 0

  $scope.navigate =(hide)->
    $scope.showCategory = !hide

  $scope.$watch '[loaded.services, loaded.locations]', (values) ->
    $scope.list_category = false if !!$state.params.q || $state.params.type == '0'
    delete $state.params.services
    delete $state.params.type
    $scope.query = $state.params
    if values[0] && values[1]
      $scope.searchCategory()
      $scope.favorite()
      $scope.search() if $scope.selected.value == 'category' && !!$scope.selectedService == false

angular.module('client').controller('VendorCatalogueCtrl', Ctrl)
