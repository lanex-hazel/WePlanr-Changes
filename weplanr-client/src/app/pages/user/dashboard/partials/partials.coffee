angular.module('client').directive 'userFavourite',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/favourite.html'

angular.module('client').directive 'vendorsTogoList',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/vendors_togo.html'

angular.module('client').directive 'userDate',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/date.html'

angular.module('client').directive 'userBudget',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/budget.html'

angular.module('client').directive 'userTodo',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/todo.html'

angular.module('client').directive 'userMessage', [
  '$rootScope','Message','Session','$state','$firebaseObject','$timeout','$interval','BASE_ENDPOINT'
  ($rootScope,Message,Session,$state,$firebaseObject,$timeout,$interval,BASE_ENDPOINT)->
    restrict: 'E'
    replace: true
    templateUrl: 'app/pages/user/dashboard/partials/message.html'
    link: (scope, element, attrs)->
      $rootScope.preloader.autoStop = no
      currentUser = Session.get('currentUser')
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
            unreadMsgs = $firebaseObject(rootRef.child("/unread_messages/#{currentUser.wedding_details.uid}"))
            window.firebaseUnwatchers.push unreadMsgs.$watch ->
              total = 0
              unreadIds = []
              unreadMerge = angular.merge({}, unreadMsgs.booking, unreadMsgs.inquiry)
              angular.forEach unreadMerge, (val, key)->
                unreadIds.push(key)
                total += val
              scope.unreadCount = total
              Message.snippets('uids[]': unreadIds).$promise.then (res)->
                $rootScope.preloader.show = no
                scope.snippets = res.data.slice(0,3)
                index = 0
                scope.currentSnippet = scope.snippets[index]
                return if scope.snippets.length < 2
                revolver = $interval ->
                  index += 1
                  index = 0 if index >= scope.snippets.length
                  scope.currentSnippet = scope.snippets[index]
                , 5000
                scope.$on '$destroy', -> $interval.cancel(revolver)

          $timeout((-> fetchMsgs()), 2000)

      signInFirebase()

      scope.goToMsg = ->
        $state.go('user.messages', chat: scope.currentSnippet.attributes.uid)
      img_endpoint = BASE_ENDPOINT.replace('api', '')
      scope.sanitizeLink = (link)->
        if /^http/.test(link) then link else (img_endpoint + link)
]

angular.module('client').directive 'userProfile',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/dashboard/partials/profile.html'
