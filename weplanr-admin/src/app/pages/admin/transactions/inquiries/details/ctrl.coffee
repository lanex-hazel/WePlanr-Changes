Ctrl = ($scope,$state,Inquiry)->

  $scope.obj = []
  $scope.loading = false

  $scope.goBack = ->
    window.history.back()

  getData = ->
    $scope.loading = true
    Inquiry.get(id: $state.params.id).$promise.then (res)->
      $scope.obj = res.data
      $scope.loading = false

  getData()

angular.module('client').controller('InquiriesShowCtrl', Ctrl)