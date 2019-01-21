Ctrl = ($scope,$state,growl,Feature)->

  $scope.loading = true
  Feature.query().$promise.then (res)->
    $scope.features = res.data
  .finally ->
    $scope.loading = false

  $scope.updateStatus =(obj)->
    Feature.update(id: obj.id, data: attributes: obj.attributes).$promise
      .then (res)->
        obj = res.data
        growl.success("Successfully updated")
      .catch (err)->
        growl.error("Update failed")

  

angular.module('client').controller('SettingsCtrl', Ctrl)