Ctrl = ($scope,$state,Invoice,Session)->
  $scope.currentVendor = Session.get('currentVendor')
  Invoice.get(id: $state.params.payment_id).$promise.then (res)->
    $scope.obj = res.data

angular.module('client').controller('VendorPaymentCtrl', Ctrl)
