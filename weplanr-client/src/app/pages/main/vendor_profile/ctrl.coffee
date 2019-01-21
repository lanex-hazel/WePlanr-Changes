Ctrl = ($scope,$state,$rootScope,growl,Vendor,Session,ModalService)->
  $scope.header_params =
    query: Session.get('curQuery')
  $scope.header_params.query.search = true if $scope.header_params.query?
  $scope.faveList =
    if !!Session.getFaveList()
      Session.getFaveList()
    else
      []
  selectedVendor = ''
  $scope.showLocation = $state.params.location

  $scope.details = ->
    $scope.loading = true
    Vendor.get(vendor_uid: $state.params.id).$promise
      .then (resp) ->
        selectedVendor = resp.data
        $scope.vendor = resp.data.attributes
        $scope.vendor.cover_photo =
          if resp.data.attributes.cover_photo
            resp.data.attributes.cover_photo
          else if resp.data.attributes.photo_urls.length > 0
            resp.data.attributes.photo_urls[0].url
        $rootScope.search_contact_name = $scope.vendor.business_name
        $rootScope.pageTitle = $scope.vendor.business_name
        $rootScope.pageDescription = $scope.vendor.about
      .finally ->
        $scope.loading = false

  $scope.favorite = ->
    $scope.faveList.push Vendor.formatVendor(selectedVendor)
    Session.setFaveVendors($scope.faveList)
    swal(FAVOURITE_MSG)

  $scope.unfavorite = ->
    # swal(UNFAVE_WARNING).then (isConfirm) ->
    #   if isConfirm
    index = $scope.isFave(selectedVendor)
    $scope.faveList.splice index, 1
    Session.setFaveVendors($scope.faveList)
    swal(UNFAVOURITE_MSG)

  $scope.isFave = ->
    $scope.faveList.findIndex((el) -> el.id == parseInt(selectedVendor.id))

  $scope.favoriteVendor =(obj)->
    $scope.faveList.push Vendor.formatVendor(obj)
    Session.setFaveVendors($scope.faveList)
    swal(FAVOURITE_MSG)

  $scope.unfavoriteVendor =(obj)->
    # swal(UNFAVE_WARNING).then (isConfirm) ->
    #   if isConfirm
    index = $scope.faveList.findIndex((el) -> el.id == obj.id)
    $scope.faveList.splice index, 1
    Session.setFaveVendors($scope.faveList)
    swal(UNFAVOURITE_MSG)

  $scope.recommend = ->
    $scope.loading = true
    Vendor.getlist(number: 1, size: 8).$promise
      .then (response)->
        $scope.collection = response.data
      .finally ->
        $scope.loading = false

  $scope.details()
  $scope.recommend()

angular.module('client').controller('VendorProfileCtrl', Ctrl)
