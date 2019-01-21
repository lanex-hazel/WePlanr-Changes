Ctrl = ($scope,$rootScope,$state,$window,$timeout,growl,User,Session,BASE_ENDPOINT)->

  $scope.loginAs = (obj)->
    Session.loginAs(id: obj.id).$promise
      .then (res)->
        encodedToken = btoa(res.data.token)
        $window.open "https://weplanr.spstage.com/index?atoken=#{encodedToken}", "_blank"

  $scope.collection = []
  $scope.searchName = $state.params.name
  $scope.statusFilter = $state.params.status or 'all'
  $scope.loading = false
  $scope.page =
    number: if $rootScope.currentPage then $rootScope.currentPage else 1

  signupRangepicker =  $('#signup-rangepicker')
  lastRangepicker =  $('#last-seen-rangepicker')
  rangepickerParams =
    autoUpdateInput: no
    timePicker: on
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
    signupRangepicker
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        signupRangepicker.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
      )
    lastRangepicker
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        lastRangepicker.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
      )

    if $state.params.lastSeen
      selected = rangepickerParams.ranges[$state.params.lastSeen]
      lastRangepicker.data('daterangepicker').startDate = selected[0]
      lastRangepicker.data('daterangepicker').endDate = selected[1]
      lastRangepicker.val(selected[0].format('DD MMM YYYY') + ' - ' + selected[1].format('DD MMM YYYY'))
    $scope.getlist($scope.page.number)

  getFilters = ->
    filters = status: $scope.statusFilter
    filters.customer_name = $scope.searchName if $scope.searchName
    if signupRangepicker.val() isnt ''
      filters.created_since = signupRangepicker.data('daterangepicker').startDate.toISOString()
      filters.created_until = signupRangepicker.data('daterangepicker').endDate.toISOString()
    if lastRangepicker.val() isnt ''
      filters.active_since = $('#last-seen-rangepicker').data('daterangepicker').startDate.toISOString()
      filters.active_until = lastRangepicker.data('daterangepicker').endDate.toISOString()
    filters


  $scope.downloadCSV = ->
    params = angular.extend(t: Session.getToken(), getFilters())
    $window.location.href = "#{BASE_ENDPOINT}/admin/users/csv?#{jQuery.param(params)}"
  
  $scope.getlist =(page)->
    $scope.loading = true
    $rootScope.currentPage = page
    filters = getFilters()
    User.getList(angular.extend(number: page, filters)).$promise
      .then (response)->
        $scope.collection = response.data
        $scope.meta = response.meta
        $scope.loading = false
      .catch (err)->
        growl.error("Failed")
        $scope.loading = false

  

angular.module('client').controller('UserCtrl', Ctrl)
