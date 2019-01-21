Ctrl =($scope,$state,$location,$timeout,Session)->
  ctrl = this

  ctrl.$onInit = ->
    @.label_options =[
      {value: 'favorite', name: 'favourites'},
      {value: 'category', name: 'all categories'}
    ]
    @.filter_service = false
    $timeout ->
      ctrl.selected = ctrl.label_options[Number($state.params.type)] if !!$state.params.type
      ctrl.showCategory = true

  ctrl.changeCategory =(item)->
    @.selected = item
    isCategory = @.selected.value == 'category'
    @.showList(isCategory)
    @.filter_service = true if @.selected.value is 'favorite'

  ctrl.showList =(showCategory=false)->
    delete @.query.type
    delete @.query.services
    if !showCategory
      @.listCategory = false
    else
      @.listCategory = true
      $location.search('type', 1)

    if @.selected.value == 'category' && !!@.selectedService == false && !showCategory
      @.search()
      $location.search(angular.extend({'type': 1},@.query))
    else if @.selected.value == 'category' && @.selectedService != ''
      @.searchCategory()
      $location.search(angular.extend({'type': 1, 'services':@.selectedService},@.query))
    else if @.selected.value == 'favorite'
      @.favorite()
      $location.search(angular.extend({'type': 0, 'services':@.selectedService},@.query))

  ctrl.isFave =(obj)->
    @.faveVendors.findIndex((el) -> el.id == obj.id)

  ctrl.filterLocation =(item)->
    @.selectLocation = item
    if item.attributes.name == 'ALL LOCATION'
      @.query.locations = ''
    else
      @.query.locations = @.selectLocation.attributes.name
    @.showList()

  ctrl.setService =(service)->
    @.selectedService = service
    @.filter_service = true
    @.showList()

  ctrl.navigate =(hide)->
    @.showCategory = !hide

  return
angular.module('client').component 'vendorCatalogue',
  templateUrl: 'app/components/vendor_catalogue/index.html'
  controller: Ctrl
  bindings:
    loading: "<"
    query: "="
    count: "<"
    locations: "<"
    categories: "<"
    search: "&"
    searchCategory: "&"
    favorite: "&"
    vendors: "<"
    faveVendors: "<"
    searchList: "<"
    unfave: "&"
    fave: "&"
    selectedService: "="
    selectLocation: "="
    selected: "="
    listCategory: "<"