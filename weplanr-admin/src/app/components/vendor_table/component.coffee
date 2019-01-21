Ctrl = ($scope,Vendor,Session,growl,$window) ->

  $scope.loginAs = (obj)->
    Session.loginAs(id: obj.attributes.user_id).$promise
      .then (res)->
        encodedToken = btoa(res.data.token)
        $window.open "https://weplanr.spstage.com/index?atoken=#{encodedToken}", "_blank"

  $scope.invite = (obj) ->
    Vendor.invite(id: obj.id).$promise
      .then (res)->
        obj.attributes.status = 'Invited'
        growl.success 'Invitation sent'
      , (res)->
        console.error 'error on invite', res
        growl.error 'Invite failed. Please try again later.'


  ctrl = this

  return

angular.module('client').component 'vendorTable',
  templateUrl: 'app/components/vendor_table/index.html'
  controller: Ctrl
  bindings:
    collection: "="
    loading: "="
    delete: "&"
