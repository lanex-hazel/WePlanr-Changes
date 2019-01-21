angular.module('client').config [
  '$stateProvider','$locationProvider','$urlRouterProvider'
  ($stateProvider,$locationProvider,$urlRouterProvider) ->

    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'vendor',
        url: '/vendor',
        templateUrl: 'app/pages/vendor/index.html'
        controller: 'VendorCtrl'
        abstract: true

      .state 'vendor.category',
        url: '/category',
        templateUrl: 'app/pages/vendor/category/index.html'
        controller: 'VendorCategoryCtrl'
        auth_vendor: true

      .state 'vendor.dashboard',
        url: '/dashboard',
        templateUrl: 'app/pages/vendor/dashboard/index.html'
        controller: 'VendorDashboardCtrl'
        title: 'Dashboard'
        auth_vendor: true

      .state 'vendor.messages',
        url: '/messages?chat',
        templateUrl: 'app/pages/vendor/messages/index.html'
        controller: 'VendorMessagesCtrl'
        title: 'Messages'
        auth_vendor: true
        backTitle: 'messages'

      .state 'vendor.raise_quote',
        url: '/raise-quote/:slug',
        templateUrl: 'app/pages/vendor/raise_quote/index.html'
        controller: 'RaiseQuoteCtrl'
        title: 'Raise Quote'
        auth_vendor: true
        params:
          weddingId: null
          weddingDate: null
          weddingName: null

      .state 'vendor.quote',
        url: '/quote/:quote_id'
        templateUrl: 'app/pages/vendor/quote/index.html'
        controller: 'VendorQuoteCtrl'
        title: 'Quote'
        auth_vendor: true
        
      .state 'vendor.payment',
        url: '/payments/:payment_id'
        templateUrl: 'app/pages/vendor/payment/index.html'
        controller: 'VendorPaymentCtrl'
        title: 'View Payment'
        auth_vendor: true

      .state 'vendor.settings',
        url: '/settings?tab&code',
        templateUrl: 'app/pages/vendor/settings/index.html'
        controller: 'VendorSettingsCtrl'
        title: 'Edit Settings'
        auth_vendor: true

      .state 'vendor.search',
        url: '/search?q&locations&services&date&search',
        templateUrl: 'app/pages/vendor/search/index.html'
        controller: 'VendorSearchCtrl'
        auth_vendor: true
        backTitle: 'search results'

      .state 'vendor.show',
        url: '/show/:id',
        templateUrl: 'app/pages/vendor/show/index.html'
        controller: 'VendorShowCtrl'
        auth_vendor: true
        backTitle: 'profile'
        params:
          location: false

      .state 'vendor.stats',
        url: '/statistics/:slug',
        templateUrl: 'app/pages/vendor/stats/index.html'
        controller: 'VendorStatsCtrl'
        auth_vendor: true

      .state 'vendor.calendar',
        url: '/calendar',
        templateUrl: 'app/pages/vendor/calendar/index.html'
        controller: 'VendorCalendarCtrl'
        auth_vendor: true

      .state 'vendor.earnings',
        url: '/earnings',
        templateUrl: 'app/pages/vendor/earnings/index.html'
        controller: 'VendorEarningsCtrl'
        auth_vendor: true

      .state 'vendor.transactions',
        url: '/transactions?start&end',
        templateUrl: 'app/pages/vendor/transactions/index.html'
        controller: 'VendorTransactionCtrl'
        auth_vendor: true
        reloadOnSearch: false

      .state 'vendor.favourites',
        url: '/favourites',
        templateUrl: 'app/pages/vendor/favourites/index.html'
        controller: 'VendorFavouriteCtrl'
        auth_vendor: true
        backTitle: 'favourites'

      .state 'vendor.customer_profile',
        url: '/customer/:id',
        templateUrl: 'app/pages/vendor/customer_profile/index.html'
        controller: 'CustomerProfileCtrl'
        auth_vendor: true
]
