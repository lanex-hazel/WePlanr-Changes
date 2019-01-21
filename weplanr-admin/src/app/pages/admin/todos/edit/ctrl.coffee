Ctrl = ($scope,$state,$stateParams,growl,Todo)->
  init = ->
    $scope.loading = yes
    Todo.get(id: $stateParams.id).$promise
      .then (response)->
        $scope.obj = response.data.attributes
        $scope.loading = no
      .catch (err)->
        growl.error('Failed')
        $scope.loading = no
  
  init()

  $scope.save = ->
    Todo.update(id: $stateParams.id, data: attributes: $scope.obj).$promise
      .then (data)->
        growl.success('Successfully Updated.')
      .catch (err)->
        growl.error('Unable to update.')

  
angular.module('client').controller('TodoEditCtrl', Ctrl)
