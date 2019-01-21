Ctrl = ($scope,$rootScope,$stateParams,$firebaseObject,growl,User,Session)->

  $scope.wedding =
    date: moment(moment().format('YYYY-MM-DD'))
  id = $stateParams.id
  $scope.vendor = Session.get('currentVendor')
  $scope.loading = false

  getDetails = ->
    $scope.loading = true
    User.customer(uid: id).$promise
      .then (res)->
        $scope.loading = false
        $scope.wedding = res.data.attributes
        date = if !!$scope.wedding.date then $scope.wedding.date else moment(moment().format('YYYY-MM-DD'))
        $scope.wedding_date = User.wedding_date(date)
        $scope.active = moment($scope.wedding.last_active).format('[Active since ]MMMM YYYY')
        $rootScope.search_contact_name = $scope.wedding.name
    $scope.subject = " has been reported by " + $scope.vendor.business_name

  $scope.replaceText =(str)->
    str.replace(/&/g, 'and') if !!str

  getDetails()
  rootRef = firebase.database().ref()
  status = $firebaseObject(rootRef.child("/last_activity_time/#{id}"))
  status.$watch (evt)->
    $scope.wedding.online = status.$value isnt null && status.$resolved

angular.module('client').controller('CustomerProfileCtrl', Ctrl)