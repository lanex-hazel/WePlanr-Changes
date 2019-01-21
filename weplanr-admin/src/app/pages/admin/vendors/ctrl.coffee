Ctrl = ($scope,$state,$window,$rootScope,growl,Upload,BASE_ENDPOINT,$http,$timeout,Vendor,Session)->

  $scope.collection = []
  $scope.searchName = $state.params.name
  $scope.statusFilter = $state.params.status or 'all'
  $scope.uploadOngoing = false
  $scope.loading = false
  $scope.data =
    collection: []
    count: 0
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
        console.log picker
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
    filters =
      status: $scope.statusFilter
    filters.business_name = $scope.searchName if $scope.searchName
    if signupRangepicker.val() isnt ''
      filters.created_since = signupRangepicker.data('daterangepicker').startDate.toISOString()
      filters.created_until = signupRangepicker.data('daterangepicker').endDate.toISOString()
    if lastRangepicker.val() isnt ''
      filters.active_since = lastRangepicker.data('daterangepicker').startDate.toISOString()
      filters.active_until = lastRangepicker.data('daterangepicker').endDate.toISOString()
    filters


  $scope.getlist =(page)->
    $scope.loading = true
    $rootScope.currentPage = page
    filters = getFilters()
    Vendor.getList(angular.extend(number: page, filters)).$promise
      .then (response) ->
        $scope.data.collection = response.data
        $scope.data.count = response.meta.record_count
        $scope.meta = response.meta
      .catch (response) ->
        growl.error('No data found.')
      .finally ->
        $scope.loading = false

  $scope.search = ->
    $scope.getlist($scope.page.number)

  $scope.downloadCSV = ->
    filters = getFilters()
    params = angular.extend(t: Session.getToken(), filters)
    $window.location.href = "#{BASE_ENDPOINT}/admin/vendors/csv?#{jQuery.param(params)}"

  $scope.destroy =(obj)->
    Vendor.delete(vendor_uid: obj.attributes.slug).$promise
      .then (data)->
        $scope.getlist($scope.page.number)
        growl.success(MESSAGES.DELETE_SUCCESS)

  $scope.submit =(form)->
    params =
      data:
        type: 'vendors'
        attributes: $scope.object
    if form.$valid
      Vendor.update(params).$promise
        .then (data)->
          $scope.getlist()
          growl.success(MESSAGES.CREATE_SUCCESS)
        .catch (err)->
          growl.success('Create failed.')
  
  $scope.$watch 'myFile', (newValue, oldValue)->
    if newValue
      $scope.uploadOngoing = true
      fd = new FormData
      fd.append 'file', newValue._file
      $http.post BASE_ENDPOINT + "/admin/vendors/csv_upload", fd,
        transformRequest: angular.identity
        headers:
          'Content-Type': undefined
          'Accept': 'application/vnd.api+json'
          'Authorization': "Token token=\"#{Session.getToken()}\""
        fd
      .then (data)->
        console.log 'upload success', data
        angular.element("input[type='file']").val(null)
        $scope.showErrors(data.data.data)
        $scope.getlist($scope.page.number)
        growl.success('Successfully Uploaded CSV file.') unless $scope.errors.length
      .catch (data)->
        console.error 'error on upload', data
        #growl.error('Failed to upload CSV file.')
      .finally ->
        $scope.uploadOngoing = false
  $scope.showErrors = (row)->
    $scope.errors = []
    angular.forEach row, (value, key) ->
      if value.errors
        angular.forEach value.errors, (error, k)->
          $scope.errors.push "Error on #{value.attributes.business_name} : #{error}"
    if $scope.errors.length
      errorMsg = ["But, please check the following rows:", $scope.errors].join("\n")
      swal('CSV Uploaded', errorMsg, 'warning')
  


angular.module('client').controller('VendorCtrl', Ctrl)
