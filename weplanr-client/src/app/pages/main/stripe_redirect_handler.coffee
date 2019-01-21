Ctrl = ($scope,$state,Session,MyVendor)->
  $scope.currentUser = Session.get('currentUser')
  $scope.currentVendor = Session.get('currentVendor')

  return unless $state.params.code
  return unless $scope.currentVendor

  MyVendor.update(id: $scope.currentVendor.slug, data: attributes: stripe_auth_code: $state.params.code).$promise
    .then (res)->
      $scope.currentUser.connected_to_stripe = yes
      Session.set('currentUser', $scope.currentUser)

    .finally (res)->
      if raiseQuoteParams = Session.get('raiseQuoteParams')
        Session.remove('raiseQuoteParams')
        $state.go('vendor.raise_quote', raiseQuoteParams)
      else
        $state.go('vendor.settings', tab: 'account')

angular.module('client').controller('StripeRedirectHandlerCtrl', Ctrl)
