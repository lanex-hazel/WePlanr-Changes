angular.module('client').config [
  '$stateProvider','$locationProvider','$urlRouterProvider'
  ($stateProvider,$locationProvider,$urlRouterProvider) ->

    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'auth',
        templateUrl: 'app/pages/auth/index.html'
        abstract: true

      .state 'auth.login',
        url: '/login',
        templateUrl: 'app/pages/auth/login/index.html'
        controller: 'LoginCtrl'
        unauthenticated: yes
]
