angular.module('client').directive 'vendorProfile', ->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/admin/vendor-details/partials/profile.html'
  link: (scope, elem, attrs) ->

    scope.addTags =(item, model, select)->
      if typeof item == 'string'
        scope.selectTag.push item
      else
        for tag in model
          scope.selectTag.push tag
      scope.vendor.services = scope.selectTag
    
    scope.removeTags =(item, model, select)->
      scope.vendor.services = scope.selectTag
      scope.vendor.services.splice(scope.vendor.services.indexOf(item),1)

    scope.selectedFnc =(data, index)->
      scope.newVar.links[data].social = index

    scope.updateCustomFee = ->
      if scope.vendor.vendor_type isnt 'custom'
        scope.vendor.custom_vendor_fee_flat = 0
        scope.vendor.custom_vendor_fee_pcg = 0

angular.module('client').directive 'vendorAccount', ->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/admin/vendor-details/partials/account.html'


angular.module('client').directive 'vendorPhotos', ->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/admin/vendor-details/partials/photos.html'

angular.module('client').filter 'exclude', (filterFilter) ->
  (input, filterEach, exclude) ->
    filterEach.forEach (item) ->
      if angular.equals(item, exclude)
        return
      input = filterFilter(input, '!' + item)
      return
    input
