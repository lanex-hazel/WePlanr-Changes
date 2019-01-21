Ctrl = ($scope) ->
  $scope.setActiveFaq = (question) ->
    if $scope.activeFaq == question
      $scope.activeFaq = ''
    else
      $scope.activeFaq = question

angular.module('client').controller('VendorLandingCtrl', Ctrl)
