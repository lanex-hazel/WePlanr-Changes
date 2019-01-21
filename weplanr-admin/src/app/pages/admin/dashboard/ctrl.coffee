Ctrl = ($scope,$state,Dashboard,growl)->
  $scope.loading = yes

  $scope.selectedRange = 'Last 30 days'
  $scope.rangeOptions =
    'Last 24 hours': [moment().subtract(24, 'hours'), moment()]
    'Last 7 days': [moment().subtract(7, 'days').startOf('day'), moment()]
    'Last 14 days': [moment().subtract(14, 'days').startOf('day'), moment()]
    'Last 30 days': [moment().subtract(30, 'days').startOf('day'), moment()]
    'Last 60 days': [moment().subtract(60, 'days').startOf('day'), moment()]
    'Last 90 days': [moment().subtract(90, 'days').startOf('day'), moment()]
    'More than 90 days': [moment('14Feb2017', 'DDMMMYYYY'), moment().subtract(91, 'days').endOf('day')]

  $scope.fetchData = ->
    $scope.loading = yes
    params =
      active_since: $scope.rangeOptions[$scope.selectedRange][0]
      active_until: $scope.rangeOptions[$scope.selectedRange][1]
    Dashboard.query(params).$promise
      .then (res)->
        $scope.data = res.data
      .finally ->
        $scope.loading = no

  $scope.generateSitemap = ->
    growl.info('Generating sitemap...')
    Dashboard.generateSitemap().$promise
      .then (res)->
        growl.success('Generated sitemap successfully')

  $scope.fetchData()

angular.module('client').controller('DashboardCtrl', Ctrl)
