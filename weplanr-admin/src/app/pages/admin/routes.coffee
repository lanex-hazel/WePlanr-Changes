angular.module('client').config [
  '$stateProvider','$locationProvider','$urlRouterProvider'
  ($stateProvider,$locationProvider,$urlRouterProvider) ->

    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'admin',
        url: '',
        templateUrl: 'app/pages/admin/index.html'
        controller: 'AdminCtrl'
        abstract: true

      .state 'admin.dashboard',
        url: '/dashboard'
        params:
          page: no
        templateUrl: 'app/pages/admin/dashboard/index.html'
        controller: 'DashboardCtrl'
        unauthenticated: no

      .state 'admin.vendors',
        url: '/businesses?name&status&lastSeen'
        params:
          page: false
        templateUrl: 'app/pages/admin/vendors/index.html'
        controller: 'VendorCtrl'
        unauthenticated: no

      .state 'admin.vendors_detail',
        url: '/businesses/detail/:id',
        templateUrl: 'app/pages/admin/vendor-details/index.html',
        controller: 'VendorDetailCtrl'
        unauthenticated: no
      
      .state 'admin.users',
        url: '/couples',
        template: '<div ui-view></div>',
        abstract: true
      
      .state 'admin.users.index',
        url: '?status&lastSeen'
        templateUrl: 'app/pages/admin/users/index.html',
        controller: 'UserCtrl'
        unauthenticated: no
      
      .state 'admin.users.detail',
        url: '/:id',
        templateUrl: 'app/pages/admin/users/detail/index.html',
        controller: 'UserDetailCtrl'
        unauthenticated: no

      .state 'admin.todos',
        url: '/todos'
        templateUrl: 'app/pages/admin/todos/index.html'
        controller: 'TodoCtrl'
        unauthenticated: no

      .state 'admin.todos_edit',
        url: '/todos/:id'
        templateUrl: 'app/pages/admin/todos/edit/index.html'
        controller: 'TodoEditCtrl'
        unauthenticated: no

      .state 'admin.settings',
        url: '/settings'
        templateUrl: 'app/pages/admin/settings/index.html'
        controller: 'SettingsCtrl'
        unauthenticated: no

      .state 'admin.customer_rewards',
        url: '/couple-rewards?status'
        templateUrl: 'app/pages/admin/customer_rewards/index.html'
        controller: 'CustomerRewardsCtrl'
        unauthenticated: no

      .state 'admin.vendor_rewards',
        url: '/business-rewards?status'
        templateUrl: 'app/pages/admin/vendor_rewards/index.html'
        controller: 'VendorRewardsCtrl'
        unauthenticated: no

      .state 'admin.transactions',
        url: ''
        templateUrl: 'app/pages/admin/transactions/index.html',
        controller: 'TransactionCtrl'
        abstract: true

      .state 'admin.transactions.inquiries',
        url: '/inquiries'
        template: '<div ui-view></div>',
        abstract: true

      .state 'admin.transactions.inquiries.index',
        url: '?page='
        templateUrl: 'app/pages/admin/transactions/inquiries/index.html'
        controller: 'InquiriesCtrl'
        unauthenticated: no

      .state 'admin.transactions.inquiries.show',
        url: '/detail/:id'
        templateUrl: 'app/pages/admin/transactions/inquiries/details/index.html'
        controller: 'InquiriesShowCtrl'
        unauthenticated: no

      .state 'admin.transactions.quotes',
        url: '/quotes'
        template: '<div ui-view></div>',
        abstract: true

      .state 'admin.transactions.quotes.index',
        url: '?page&dateRaised'
        templateUrl: 'app/pages/admin/transactions/quotes/index.html'
        controller: 'QuotesCtrl'
        unauthenticated: no
        reloadOnSearch: false

      .state 'admin.transactions.quotes.show',
        url: '/detail/:id'
        templateUrl: 'app/pages/admin/transactions/quotes/details/index.html'
        controller: 'QuotesShowCtrl'
        unauthenticated: no

      .state 'admin.transactions.bookings',
        url: '/bookings'
        template: '<div ui-view></div>',
        abstract: true

      .state 'admin.transactions.bookings.index',
        url: '?page&dateRaised'
        templateUrl: 'app/pages/admin/transactions/bookings/index.html'
        controller: 'BookingsCtrl'
        unauthenticated: no
        reloadOnSearch: false

      .state 'admin.transactions.bookings.show',
        url: '/detail/:id'
        templateUrl: 'app/pages/admin/transactions/bookings/details/index.html'
        controller: 'BookingsShowCtrl'
        unauthenticated: no
]
