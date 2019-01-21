Ctrl =($scope,Vendor)->
  ctrl = this

  ctrl.loadMore = ->
    if @.currentPage < @.state.totalPages && !@.state.loading
      @.state.scrollable = true
      @.search({params:@.data,new_search:false})
    else
      @.state.scrollable = false

  ctrl.isFave =(id)->
    @.faveVendors.indexOf id if id?

  ctrl.scroll =(evt,isLeft)->
    elem = angular.element(evt.target).closest('.hide-desktop')
    move = 0
    if isLeft
      if evt.currentTarget.offsetLeft > elem.scrollLeft() + move
        @.loadMore()
        move = evt.currentTarget.offsetLeft - elem.scrollLeft()
        elem.animate({ scrollLeft: '+='+ move}, 500)
      else
        elem.animate({ scrollLeft: '+=253'}, 500)
    else
      elem.animate({ scrollLeft: '-=253'}, 500)

  ctrl.fetchServices =(obj)->
    Vendor.allServices(obj)
  
  return

angular.module('client').component 'searchResultList',
  restrict: "E"
  templateUrl: 'app/components/search_result_list/index.html'
  controller: Ctrl
  bindings:
    collection: "<"
    data: "<"
    currentPage: "="
    state: "="
    search: "&"
    fave: "&"
    unfave: "&"
    redirectUrl: "@"
    searchTitle: "="
    faveVendors: "<"
