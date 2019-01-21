Ctrl = ($scope,$state,growl,Todo)->
  init = ->
    $scope.loading = yes
    Todo.getList().$promise
      .then (response)->
        $scope.collection = response.data
        console.log $scope.collection
        $scope.loading = false
      .catch (err)->
        growl.error('Failed')
        $scope.loading = no
  
  init()

  

angular.module('client').controller('TodoCtrl', Ctrl)
