Ctrl = ($scope,$state,growl,Invoice,Session,VendorQuote)->
  $scope.currentUser = Session.get('currentUser')
  vendorId = $state.params.vendor_slug or 'na'
  $scope.details = ->
    Invoice.get(id: $state.params.no).$promise.then (res)->
      $scope.obj = res.data

  $scope.payFull =(quoteNo)->
    swal(
      text: "ARE YOU SURE YOU WANT TO PAY #{$scope.obj.attributes.vendor.business_name} IN FULL? "
      type: 'warning'
      showCancelButton: true
      confirmButtonText: 'Yes'
      cancelButtonText: 'No'
      closeOnCancel: true
      closeOnConfirm: true
    ).then (confirmed) ->
      return unless confirmed
      $scope.loading = on
      VendorQuote.fulfill(vendor_id: vendorId, id: quoteNo).$promise
        .then (res)->
          # $scope.obj = res.data
          $scope.details()
          growl.success('Payment Successful')
        .finally ->
          $scope.loading = no

  $scope.details()

angular.module('client').controller('PaymentCtrl', Ctrl)
