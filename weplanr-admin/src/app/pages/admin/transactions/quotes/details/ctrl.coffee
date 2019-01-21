Ctrl = ($scope,$state,$location,Quote)->

  $scope.obj = []
  $scope.loading = false

  $scope.goBack = ->
    window.history.back()

  getData = ->
    $scope.loading = true
    Quote.get(id: $state.params.id).$promise.then (res)->
      $scope.obj = res.data.attributes
      $scope.loading = false

  getData()

angular.module('client').controller('QuotesShowCtrl', Ctrl)