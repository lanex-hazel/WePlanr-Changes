Ctrl = ($scope,$state,$location,$window,$timeout,Quote,Session,BASE_ENDPOINT)->

  $scope.collection = []
  $scope.loading = false
  $scope.page = if !!$state.params.page then Number($state.params.page) else 1
  $scope.dataFilter = if !!$state.params.dateRaised then JSON.parse($state.params.dateRaised) else {}

  quoteDaterange = $("#quote-date-rangepicker")
  rangepickerParams =
    autoUpdateInput: no
    drops: 'up'
    locale:
      format: 'DD MMM YYYY'
      cancelLabel: 'Clear'
    ranges:
      'Last 24 hours': [moment().subtract(24, 'hours'), moment()]
      'Last 7 days': [moment().subtract(7, 'days').startOf('day'), moment()]
      'Last 14 days': [moment().subtract(14, 'days').startOf('day'), moment()]
      'Last 30 days': [moment().subtract(30, 'days').startOf('day'), moment()]
      'Last 60 days': [moment().subtract(60, 'days').startOf('day'), moment()]
      'Last 90 days': [moment().subtract(90, 'days').startOf('day'), moment()]
      'More than 90 days': [moment('14Feb2017', 'DDMMMYYYY'), moment().subtract(91, 'days').endOf('day')]
  $timeout ->
    quoteDaterange
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        quoteDaterange.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
        $scope.dateRange = picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY')
      )

  getQuotesFilters = ->
    filters = {}
    if quoteDaterange.val() isnt ''
      filters.created_since = quoteDaterange.data('daterangepicker').startDate.toISOString()
      filters.created_until = quoteDaterange.data('daterangepicker').endDate.toISOString()
    else if Object.keys($scope.dataFilter).length isnt 0 && quoteDaterange.val() isnt ''
      filters = $scope.dataFilter
    filters

  $scope.getData =(page)->
    $scope.loading = true
    Quote.query(angular.extend(number: page, getQuotesFilters())).$promise.then (res)->
      $scope.collection = res.data
      $scope.count = res.meta.record_count
      $scope.loading = false
    $location.search(angular.extend(page: page, dateRaised: JSON.stringify(getQuotesFilters())))

  $scope.downloadCSV = ->
    params = angular.extend(t: Session.getToken(), getQuotesFilters())
    $window.location.href = "#{BASE_ENDPOINT}/admin/quotes/csv?#{jQuery.param(params)}"

  $scope.getData($scope.page)


angular.module('client').controller('QuotesCtrl', Ctrl)