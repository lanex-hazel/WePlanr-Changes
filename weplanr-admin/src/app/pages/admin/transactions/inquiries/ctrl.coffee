Ctrl = ($scope,$state,$location,Inquiry)->

  $scope.collection = []
  $scope.loading = false
  $scope.page = if !!$state.params.page then Number($state.params.page) else 1

  $scope.getData =(page)->
    $scope.loading = true
    Inquiry.query(number: page).$promise.then (res)->
      $scope.collection = res.data
      $scope.count = res.meta.record_count
      $scope.loading = false
    $location.search('page', page)

  $scope.getData($scope.page)

angular.module('client').controller('InquiriesCtrl', Ctrl)