angular.module('client').config [
  '$stateProvider','$locationProvider','$urlRouterProvider'
  ($stateProvider,$locationProvider,$urlRouterProvider) ->

    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise('/index')

    $stateProvider
      .state 'main',
        templateUrl: 'app/pages/main/index.html'
        controller: 'MainCtrl'
        abstract: true

      .state 'main.intro',
        url: '/index?reset_password&token&t&favourites&login&signup&menu&start&atoken'
        templateUrl: 'app/pages/main/intro/index.html'
        controller: 'IntroCtrl'
        unauthenticated: yes
        backTitle: 'our favourites'
        reloadOnSearch: false

      .state 'main.search',
        url: '/search?q&locations&services&date&search',
        params:
          redirect: false
        templateUrl: 'app/pages/main/search/index.html'
        controller: 'SearchCtrl'
        reloadOnSearch: false
        unauthenticated: yes
        backTitle: 'search results'

      .state 'main.vendorprofile',
        url: '/profile/:id',
        templateUrl: 'app/pages/main/vendor_profile/index.html'
        controller: 'VendorProfileCtrl'
        unauthenticated: yes
        backTitle: 'profile'
        params:
          location: false

      .state 'main.vendor_landing',
        url: '/vendor/app',
        templateUrl: 'app/pages/main/vendor_landing/index.html'
        controller: 'VendorLandingCtrl'
        unauthenticated: yes

      .state 'main.vendor_register',
        url: '/vendor/register?code',
        templateUrl: 'app/pages/main/vendor_register/index.html'
        controller: 'VendorRegisterCtrl'
        unauthenticated: yes

      .state 'main.confirm_account',
        url: '/confirmation_account?token',
        controller: 'ConfirmAcctCtrl'
        unauthenticated: yes

      .state 'main.directory',
        url: '/vendor/catalogue?type&services&q&locations',
        templateUrl: 'app/pages/main/directory/index.html'
        controller: 'DirectoryCtrl'
        unauthenticated: yes
        backTitle: 'vendor catalogue'
        reloadOnSearch: false

      .state 'main.policy',
        url: '/privacy-policy',
        templateUrl: 'app/pages/main/policy/index.html'
        public: yes

      .state 'main.terms',
        url: '/terms-and-conditions',
        templateUrl: 'app/pages/main/terms/index.html'
        public: yes

      .state 'main.stripe_redirect_handler',
        url: '/stripe_redirect_handler?code',
        controller: 'StripeRedirectHandlerCtrl'
        templateUrl: 'app/pages/main/loading.html'
        public: yes

]
