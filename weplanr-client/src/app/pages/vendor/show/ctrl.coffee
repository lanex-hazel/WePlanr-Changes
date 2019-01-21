Ctrl = ($scope,$state,$rootScope,growl,Vendor,MyVendor,User,Session)->

  $scope.currentVendor = Session.get('currentVendor')
  $scope.maxRating = [1,2,3,4,5]
  $scope.rate = 3
  $scope.showState =
    about: false
  $scope.selectedVendor = ''
  $scope.processing = false
  $scope.faveList = []
  $scope.header_params =
    query: Session.get('curQuery')
  $scope.header_params.query.search = true if $scope.header_params.query?
  vendorId = ''
  $scope.showLocation = $state.params.location

  $scope.details = ->
    $scope.loading = true
    Vendor.get(vendor_uid:$state.params.id).$promise
      .then (resp) ->
        vendorId = parseInt(resp.data.id)
        $scope.selectedVendor = resp.data.attributes
        $scope.selectedVendor.cover_photo =
          if resp.data.attributes.cover_photo
            resp.data.attributes.cover_photo
          else if resp.data.attributes.photo_urls.length > 0
            resp.data.attributes.photo_urls[0].url
        $rootScope.search_contact_name = $scope.selectedVendor.business_name
      .finally ->
        $scope.loading = false


  $scope.isFave = ->
    return $scope.faveList.indexOf(vendorId) if $scope.faveList.length > 0

  $scope.favorite = ->
    $scope.processing = true
    Vendor.favourite(id: vendorId).$promise
      .then (response)->
        $scope.faveVendors()
        swal(FAVOURITE_MSG)
        $scope.processing = false
      .catch (response)->
        $scope.processing = false
        growl.error('Process failed.')

  $scope.unfavorite = ->
    $scope.processing = true
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: vendorId).$promise
          .then (response)->
            $scope.faveVendors()
            swal(UNFAVOURITE_MSG)
          .catch (response)->
            growl.error('Process failed.')
    $scope.processing = false

  $scope.faveVendors = ->
    User.favorites().$promise
      .then (response)->
        $scope.faveList = response.data.map (obj)-> obj['id']
      .finally ->
        $scope.loading = false

  $scope.favoriteVendor =(obj)->
    $scope.processing = true
    Vendor.favourite(id: obj.id).$promise
      .then (response)->
        $scope.faveVendors()
        swal(FAVOURITE_MSG)
        $scope.processing = false
      .catch (response)->
        $scope.processing = false
        growl.error('Process failed.')

  $scope.unfavoriteVendor =(obj)->
    $scope.processing = true
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: obj.id).$promise
          .then (response)->
            $scope.faveVendors()
            swal(UNFAVOURITE_MSG)
          .catch (response)->
            growl.error('Process failed.')
      $scope.processing = false

  $scope.recommend = ->
    $scope.loading = true
    Vendor.getlist(number: 1, size: 8).$promise
      .then (response)->
        $scope.collection = response.data
      .finally ->
        $scope.loading = false

  $scope.details()
  $scope.faveVendors()
  $scope.recommend()

angular.module('client').controller('VendorShowCtrl', Ctrl)
