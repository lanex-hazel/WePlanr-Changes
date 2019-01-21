angular.module('client').config [
  'growlProvider', 'AnalyticsProvider',
  (growlProvider, AnalyticsProvider) ->
    growlProvider.globalDisableCountDown true
    growlProvider.globalDisableIcons(true)
    growlProvider.globalDisableCloseButton(true)
    growlProvider.globalTimeToLive(4000)

    firebase.initializeApp
      apiKey: "AIzaSyDG5RrU7FE4Zat0LsPKmgIqLgRFn1jB7D4"
      authDomain: "weplanr.firebaseapp.com"
      databaseURL: "https://weplanr.firebaseio.com"
      projectId: "weplanr"
      storageBucket: "weplanr.appspot.com"
      messagingSenderId: "222579377675"

    AnalyticsProvider
      .trackUrlParams(true)
      .setPageEvent('$stateChangeSuccess')
      .setAccount(
        tracker: 'UA-106815192-1' # WePlanr Staging
        trackEvent: on
      )
]
