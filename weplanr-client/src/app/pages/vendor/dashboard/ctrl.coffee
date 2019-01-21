Ctrl = ($scope,$state,$rootScope,growl,Vendor,MyVendor,Session,VendorMessage,Earning,$firebaseObject,$timeout,$interval,BASE_ENDPOINT)->
  $rootScope.preloader.autoStop = no

  $scope.currentVendor = currentVendor = Session.get('currentVendor')
  $scope.currentStep = 'step1'

  showViewsAnalytics = ->
    Earning.query().$promise.then (res)->
      $scope.earnings = res.data
    MyVendor.getStats(id: $scope.currentVendor.slug).$promise.then (res)->
      $scope.totals = res.data.totals
  showViewsAnalytics()

  signInFirebase = ->
    firebase.auth().signInAnonymously().catch (error)->
      console.error 'firebase auth error', error
      console.log 'retrying to authenticate firebase in 10sec...'
      $timeout((-> signInFirebase()), 10000)

    count = 0
    firebase.auth().onAuthStateChanged (user)->
      count += 1 if user
      return if count isnt 1

      fetchMsgs = ->
        rootRef = firebase.database().ref()
        unreadMsgs = $firebaseObject(rootRef.child("/unread_messages/#{currentVendor.uid}"))
        window.firebaseUnwatchers.push unreadMsgs.$watch ->
          total = 0
          unreadIds = []
          unreadMerge = angular.merge({}, unreadMsgs.booking, unreadMsgs.inquiry)
          angular.forEach unreadMerge, (val, key)->
            unreadIds.push(key)
            total += val
          $scope.unreadCount = total
          VendorMessage.snippets(vendor_uid: currentVendor.uid, 'uids[]': unreadIds).$promise.then (res)->
            $scope.snippets = res.data.slice(0,3)
            index = 0
            $scope.currentSnippet = $scope.snippets[index]
            $rootScope.preloader.show = no
            return if $scope.snippets.length < 2
            revolver = $interval ->
              index += 1
              index = 0 if index >= $scope.snippets.length
              $scope.currentSnippet = $scope.snippets[index]
            , 5000
            $scope.$on '$destroy', -> $interval.cancel(revolver)

      $timeout((-> fetchMsgs()), 2000)

  signInFirebase()

  $scope.goToMsg = ->
    uid = $scope.currentSnippet?.attributes?.uid
    $state.go('vendor.messages', chat: uid)

  img_endpoint = BASE_ENDPOINT.replace('api', '')
  $scope.sanitizeLink = (link)->
    if /^http/.test(link) then link else (img_endpoint + link)

  $scope.redirectToCalendar = (event)->
    $state.go('vendor.calendar') unless event.target.attributes['ng-click']

  $scope.personaliseDashboard = ->
    $rootScope.welcome_modal = false

angular.module('client').controller('VendorDashboardCtrl', Ctrl)
