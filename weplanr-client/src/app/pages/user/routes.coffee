angular.module('client').config [
  '$stateProvider','$locationProvider','$urlRouterProvider'
  ($stateProvider,$locationProvider,$urlRouterProvider) ->

    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'user',
        url: '/user'
        templateUrl: 'app/pages/user/index.html'
        controller: 'UserCtrl'
        abstract: true

      .state 'user.dashboard',
        url: '/dashboard',
        templateUrl: 'app/pages/user/dashboard/index.html'
        controller: 'DashboardCtrl'
        title: 'Dashboard'
        auth_user: true
        backTitle: 'dashboard'

      .state 'user.favourites',
        url: '/favourites',
        templateUrl: 'app/pages/user/favourites/index.html'
        controller: 'VendorFaveCtrl'
        title: 'Favourites'
        auth_user: true
        backTitle: 'favourites'

      .state 'user.search',
        url: '/search?q&locations&services&date&search',
        templateUrl: 'app/pages/user/search/index.html'
        controller: 'UserSearchCtrl'
        auth_user: true
        reloadOnSearch: false
        backTitle: 'search results'

      .state 'user.vendor',
        url: '/vendor',
        templateUrl: 'app/pages/user/vendor/index.html'
        controller: 'UVendorCtrl'
        abstract: true

      .state 'user.vendor.show',
        url: '/show/:id',
        templateUrl: 'app/pages/user/vendor/show/index.html'
        controller: 'UVendorShowCtrl'
        auth_user: true
        backTitle: 'profile'
        params:
          location: false

      .state 'user.messages',
        url: '/messages?chat',
        templateUrl: 'app/pages/user/messages/index.html'
        controller: 'MessagesCtrl'
        title: 'Messages'
        auth_user: true
        backTitle: 'messages'

      .state 'user.settings',
        url: '/settings?tab'
        templateUrl: 'app/pages/user/settings/index.html'
        controller: 'SettingsCtrl'
        title: 'Edit settings'
        auth_user: yes

      .state 'user.quote',
        url: '/quote/:vendor_slug/:no'
        templateUrl: 'app/pages/user/quote/index.html'
        controller: 'QuoteCtrl'
        title: 'View Quote'
        auth_user: yes

      .state 'user.payment',
        url: '/payments/:no'
        templateUrl: 'app/pages/user/payment/index.html'
        controller: 'PaymentCtrl'
        title: 'View Payment'
        auth_user: yes
        params:
          returnTo: null

      .state 'user.catalogue',
        url: '/catalogue?type&services&q&locations'
        templateUrl: 'app/pages/user/catalogue/index.html'
        controller: 'VendorCatalogueCtrl'
        title: 'Vendor Catalogue'
        auth_user: yes
        backTitle: 'vendor catalogue'
        reloadOnSearch: false

      .state 'user.calendar',
        url: '/calendar'
        templateUrl: 'app/pages/user/calendar/index.html'
        controller: 'UserCalendarCtrl'
        title: 'Calendar'
        auth_user: yes

      .state 'user.organiser',
        url: '/organisr'
        templateUrl: 'app/pages/user/organiser/index.html'
        controller: 'UserOrganiserCtrl'
        title: 'Organiser'
        backTitle: 'organisr'
        auth_user: yes
]
