Ctrl = ($scope,$state,$timeout,$location,$window,Quote,Session,BASE_ENDPOINT)->

  $scope.collection = []
  $scope.loading = false
  $scope.page = if !!$state.params.page then Number($state.params.page) else 1
  $scope.dataFilter = if !!$state.params.dateRaised then JSON.parse($state.params.dateRaised) else {}

  bookingDaterange = $("#booking-date-rangepicker")
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
    bookingDaterange
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        bookingDaterange.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
      )

  getBookingFilters = ->
    filters = {}
    if bookingDaterange.val() isnt ''
      filters.created_since = bookingDaterange.data('daterangepicker').startDate.toISOString()
      filters.created_until = bookingDaterange.data('daterangepicker').endDate.toISOString()
    else if Object.keys($scope.dataFilter).length isnt 0 && bookingDaterange.val() isnt ''
      filters = $scope.dataFilter
    filters

  $scope.getData =(page)->
    $scope.loading = true
    Quote.queryBookings(angular.extend(number: page, getBookingFilters())).$promise.then (res)->
      $scope.collection = res.data
      $scope.count = res.meta.record_count
      $scope.loading = false
    $location.search(angular.extend(page: page, dateRaised: JSON.stringify(getBookingFilters())))

  $scope.downloadCSV = ->
    params = angular.extend(t: Session.getToken(), getBookingFilters())
    $window.location.href = "#{BASE_ENDPOINT}/admin/quotes/csv_booked?#{jQuery.param(params)}"

  $scope.getData($scope.page)


angular.module('client').controller('BookingsCtrl', Ctrl)