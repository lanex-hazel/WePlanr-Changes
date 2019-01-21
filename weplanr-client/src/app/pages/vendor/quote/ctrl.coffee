Ctrl = ($scope,$state,Session,VendorQuote)->
  $scope.currentVendor = Session.get('currentVendor')
  VendorQuote.get(vendor_uid: 'n', id: $state.params.quote_id).$promise.then (res)->
    $scope.obj = res.data
    $scope.deposit = res.data.attributes.total * .4
    $scope.dueCost = res.data.attributes.total * .6
    $scope.expiryDate = moment(res.data.attributes.updated_at).add(6, 'days').format('DD MMMM YYYY')

angular.module('client').controller('VendorQuoteCtrl', Ctrl)
