Ctrl =($scope)->
  ctrl = this

  ctrl.$onInit = ->
    if @.data.services? || @.data.locations?
      @.toggle = true
    else
      @.toggle = false

  ctrl.searchToggle =(val)->
    @.toggle = !val

  ctrl.reset = ->
    @.data.services = ''
    @.data.date = ''
    @.data.locations = ''
    @.search({q:@.data})


  return

angular.module('client').component 'searchForm',
  templateUrl: 'app/components/search_form/index.html'
  controller: Ctrl
  bindings:
    search: "&"
    data: "="
    vendorTypes: "="