Ctrl = ($scope,$state,growl,MyVendor,Booking,Session)->

  $scope.currentVendor = Session.get('currentVendor')
  vendorId = Session.get('currentVendor').slug

  $scope.months = Array.apply(0, Array(12)).map (_, i) ->
    moment().month(i).format 'YYYY-MM-DD'
  $scope.events = []
  $scope.dayEvents = []
  $scope.event_dates = []
  $scope.unavailable_dates = []
  $scope.cal_view = 'month'
  $scope.uiState =
    edit: false
    add: false
    bookingLoaded: true
    blockdatesLoaded: true
    temp_bookedDates: []
    failUpd: false
  $scope.sel =
    curDay: moment().format('YYYY-MM-DD')
    curYear: moment().format('YYYY')

  $scope.getBlockDates =(date='')->
    $scope.uiState.blockdatesLoaded = false
    Booking.getBlockDates(vendor_id: vendorId).$promise
      .then (response)->
        $scope.uiState.blockdatesLoaded = true
        $scope.unavailable = response.data.fullybooked.details
        $scope.unavailable_dates = response.data.fullybooked.dates
        $scope.closed = response.data.closed.details
        $scope.closed_dates = response.data.closed.dates

  $scope.getBookings =(date='')->
    $scope.uiState.bookingLoaded = false
    Booking.getBookings(vendor_id: vendorId, view:$scope.cal_view, date:date).$promise
      .then (response)->
        $scope.uiState.bookingLoaded = true
        $scope.events = response.data
        $scope.hasEvent = response.data.length > 0
        if $scope.cal_view == 'month'
          $scope.temp_monthEvents = angular.copy($scope.events)
          $scope.event_dates = response.data.map (obj)-> obj['event_date']
          $scope.uiState.temp_bookedDates = angular.copy($scope.event_dates)
        if $scope.cal_view == 'day'
          $scope.dayEvents = response.data
          $scope.events = $scope.temp_monthEvents
          $scope.event_dates = $scope.uiState.temp_bookedDates
          $scope.event_time = response.data.map (obj)-> obj['attributes']?['schedule_time']

  $scope.onSave =(obj,day)->
    params =
      attributes: obj
    Booking.saveBooking(vendor_id: vendorId, data:params).$promise
      .then (response)->
        date= day.format('YYYY-MM-DD')
        $scope.getBookings(date)
        growl.success("Successfully booked event.")
        $scope.uiState.add = false
        $scope.uiState.failUpd = false
        arr = $scope.events.map (obj)-> obj['event_date']
        idx = arr.indexOf(date)
        if !idx > -1
          $scope.events.push {bookings: 0, event_date: date, schedules: []}
          idx = $scope.events.length - 1
        $scope.events[idx].bookings++
        $scope.events[idx].schedules.push response.data
      .catch (err)->
        $scope.uiState.failUpd = true
        growl.error(err.errors[0])

  $scope.onUpdate =(obj)->
    Booking.update(vendor_id: vendorId, id:obj.id, data:obj).$promise
      .then (response)->
        $scope.uiState.edit = false
        $scope.uiState.failUpd = false
        growl.success("Successfully updated")
        $scope.getBookings($scope.sel.curDay)
      .catch (err)->
        $scope.uiState.edit = true
        $scope.uiState.failUpd = true
        growl.error(err.errors[0])

  $scope.onRemove =(obj,day)->
    swal(REMOVEBOOKING_WARNING).then (isConfirm) ->
      if isConfirm
        Booking.delete(vendor_id: vendorId, id: obj.id).$promise
          .then (res)->
            arr = $scope.events.map (obj)-> obj['event_date']
            idx = arr.indexOf(day)
            if idx > -1
              $scope.events[idx].bookings--
              $scope.events.splice(idx,1) if $scope.events[idx].bookings == 0
            $scope.getBookings(day)
            growl.success("Removed booking.")
          .catch (err)->
            growl.error("Remove failed.")

  $scope.setUnavailable =(day, type)->
    params =
      attributes:
        date: day
        reason: type
    if type == 'closed'
      message = CLOSED_DATE_WARNING
    else
      message = FULLYBOOKED_DATE_WARNING
    swal(message).then (isConfirm) ->
      if isConfirm
        $scope.uiState.blockdatesLoaded = false
        Booking.blockDate(vendor_id: vendorId, data: params).$promise
          .then (response) ->
            $scope.getBlockDates()
            $scope.uiState.blockdatesLoaded = true
          .catch (err) ->
            $scope.uiState.blockdatesLoaded = true
            growl.error("Process failed")
      else
        $scope.uiState.blockdatesLoaded = true

  $scope.unSetUnavailable =(index, type)->
    if type == 'closed'
      id = $scope.closed[index].id
      message = UNCLOSED_DATE_WARNING
    else
      id = $scope.unavailable[index].id
      message = UNFULLYBOOKED_DATE_WARNING
    swal(message).then (isConfirm) ->
      if isConfirm
        $scope.uiState.blockdatesLoaded = false
        Booking.unblockDate(vendor_id: vendorId, id: id).$promise
          .then (response) ->
            $scope.getBlockDates()
            $scope.uiState.blockdatesLoaded = true
          .catch (err) ->
            $scope.uiState.blockdatesLoaded = true
            growl.error("Process failed")
      else
        $scope.uiState.blockdatesLoaded = true

  $scope.getBlockDates()



angular.module('client').controller('VendorCalendarCtrl', Ctrl)
