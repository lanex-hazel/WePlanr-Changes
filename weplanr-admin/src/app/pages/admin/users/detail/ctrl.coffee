Ctrl = ($scope,$state,growl,User)->

  $scope.uiState =
    currentTab: 'account'

  User.get(id: $state.params.id).$promise.then (res) ->
    $scope.currentUser = res.data.attributes
    $scope.partnerDetails = res.data.attributes.partner
    $scope.hasPartner = !!res.data.attributes.partner
    $scope.hasWedding = !!res.data.attributes.wedding_details
    $scope.weddingDetails = res.data.attributes.wedding_details
    $scope.avatar_photo = res.data.attributes.avatar_photo

  $scope.return = ->
    window.history.back()


angular.module('client').controller('UserDetailCtrl', Ctrl)