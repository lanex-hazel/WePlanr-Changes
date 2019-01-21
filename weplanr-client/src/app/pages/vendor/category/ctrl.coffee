Ctrl = ($scope,$state,Session,growl,Vendor)->

  $scope.collection = []
  $scope.obj = {}
  $scope.loading = false
  $scope.pages =
    number: 1
    size: 20

  $scope.currentUser = $scope.$parent.getUser()

  $scope.services = ["florist", "photographer"]

  $scope.list =(page,service)->
    $scope.loading = true
    Vendor.getlist(number: page.number, size: page.size, services:service).$promise
      .then (response)->
        $scope.data = response.data
        $scope.collection.push {data: $scope.data, type: service}
      .finally ->
        $scope.loading = false

  $scope.getByService = ->
    for service in $scope.services
      $scope.list($scope.pages,service)

  $scope.getByService()



angular.module('client').controller('VendorCategoryCtrl', Ctrl)

