Ctrl = ($scope,$rootScope,$timeout,growl,Session,User,Vendor)->

  $scope.collection = []
  $scope.uiState =
    loading: false
    loadMore: false
    scrollable: false
    processing: false
    remove: false
    count: 0
  totalPages  = 0
  $scope.page =
    number: 1
    size: DEFAULT_PER_PAGE
  $scope.curLimit = DEFAULT_LOAD_ITEM
  $scope.currentVendor = Session.get('currentVendor')

  $scope.list = ->
    $scope.uiState.loading = true
    User.favoritesByPage($scope.page).$promise
      .then (response)->
        $scope.curLimit = DEFAULT_LOAD_ITEM
        $scope.collection = $scope.collection.concat(response.data)
        $scope.uiState.count = response.meta.record_count
        temp_count = response.meta.record_count - DEFAULT_LOAD_ITEM
        totalPages = Math.ceil(response.meta.record_count/DEFAULT_PER_PAGE)
        $scope.uiState.scrollable = true if $scope.page.number < totalPages || $scope.curLimit < DEFAULT_PER_PAGE
      .finally ->
        $scope.uiState.loading = false

  $scope.loadMore = ->
    if $scope.page.number < totalPages
      $scope.page.number++
      $scope.list()
    else
      $scope.uiState.scrollable = false

  $scope.unfavorite =(obj, index)->
    $scope.uiState.processing = true
    $scope.uiState.remove = obj.id
    swal(UNFAVE_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.unfavourite(id: obj.id).$promise
          .then (response)->
            $('.unfavorite').remove()
            $scope.uiState.count--
            swal(UNFAVOURITE_MSG)
          .finally ->
            $scope.uiState.processing = false
            $scope.uiState.remove = null
      else
        $scope.uiState.processing = false
        $scope.uiState.remove = null

  $scope.list()


angular.module('client').controller('VendorFavouriteCtrl', Ctrl)
