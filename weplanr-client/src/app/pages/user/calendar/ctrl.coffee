Ctrl = ($scope,$state,growl,Session,User)->

  removeTime = (date) ->
    date.day(0).hour(0).minute(0).second(0).millisecond 0

  buildMonth = ($scope, start, month) ->
    $scope.weeks = []
    done = false
    date = start.clone()
    monthIndex = date.month()
    count = 0
    while !done
      $scope.weeks.push days: buildWeek(date.clone(), month)
      date.add 1, 'w'
      done = count++ > 2 and monthIndex != date.month()
      monthIndex = date.month()
    return

  buildWeek = (date, month) ->
    days = []
    i = 0

    recordFound = null
    while i < 7
      key = date.format('DD.MM.YYYY')
      recordFound = _.find $scope.records, (obj) ->
        obj[key]
      days.push
        name: date.format('dd').substring(0, 1)
        number: date.date()
        isCurrentMonth: date.month() == month.month()
        date: date
        hasRecord: recordFound[key].record_count if recordFound
        isToday: date.isSame(new Date(), "day")
      date = date.clone()
      date.add 1, 'd'
      i++
    days


  #vars
  $scope.currentUser = Session.get('currentUser')
  $scope.view = 'month'
  $scope.recordView = 'invoices'
  lastDay = Number(moment().endOf('month').format('DD'))
  $scope.months = Array.apply(0, Array(12)).map (_, i) ->
    moment().month(i)
  $scope.calendar = []
  $scope.loading = false
  $scope.changeMonth = false
  $scope.changeYear = false
  $scope.dayRecord =
    invoice: {}
    quote: {}

  #create month range
  $scope.selected = removeTime(moment())
  $scope.year = $scope.selected.clone()
  $scope.month = $scope.selected.clone()
  start = $scope.selected.clone()
  start.date 1
  removeTime(start.day(0))
  end = $scope.selected.clone()
  end.date(lastDay)
  removeTime(end.day(7))

  $scope.startDate = start.toISOString()
  $scope.endDate = end.toISOString()

  changeMonth = ->
    $scope.changeMonth = true
    $scope.month = $scope.selected.clone()
    start = $scope.selected.clone().date(1)
    end = $scope.selected.clone().date(lastDay)
    removeTime start.day(0)
    removeTime end.day(7)

  createMonth =(month)->
    startMonth =  moment(month).clone()
    startMonth.date 1
    removeTime(startMonth.day(0))
    startMonth
  
  fetchData = ->
    $scope.loading = true
    User.events(created_since: $scope.startDate, created_until: $scope.endDate).$promise
      .then (res)->
        $scope.loading = false
        $scope.records = _.union(res.data.invoices, res.data.quotes)
        $scope.invoices = res.data.invoices
        $scope.quotes = res.data.quotes

        ## build calendar
        if $scope.view == 'year' || $scope.changeYear
          $scope.calendar = []
          for month in $scope.months
            curMonth = moment(month).clone()
            startMonth =createMonth(month)
            buildMonth $scope, startMonth, curMonth
            $scope.calendar.push {year: startMonth.year(), month: curMonth.format('MMMM'), weeks: $scope.weeks}
          $scope.changeYear = false

        if $scope.view == 'month' || $scope.changeMonth
          buildMonth $scope, start, $scope.month
          $scope.changeMonth = false

        $scope.dayRecord.invoice = $scope.currentDayRecord($scope.invoices)
        $scope.dayRecord.quote = $scope.currentDayRecord($scope.quotes)
  fetchData()

  $scope.changeView =(type, date=null)->
    $scope.view = type
    today = moment()
    switch $scope.view
      when 'day'
        if date
          $scope.selected = date
          $scope.month = $scope.selected.clone()
        else if $scope.selected.year() != $scope.year.year()
          newDay = $scope.year.clone()
          $scope.selected = newDay.date(1)
          $scope.month = $scope.selected.clone()
        else if $scope.month.month() == today.month()
          $scope.selected = today
        else if $scope.selected.month() != $scope.month.month()
          newDay = $scope.month.clone()
          $scope.selected = newDay.date(1)

        start = $scope.selected.clone()
        end = $scope.selected.clone()

        $scope.startDate = start.format('YYYY-MM-DD[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-MM-DD[T]23:59:59.999[Z]')
      when 'year'
        if $scope.month.year() == today.year()
          $scope.year = today
        else if $scope.year.year() != $scope.month.year()
          newYr =  $scope.month.clone()
          $scope.year = $scope.month.clone()
          $scope.months = Array.apply(0, Array(12)).map (_, i) ->
            moment(newYr).month(i)

        start = $scope.year.clone()
        end = $scope.year.clone()
        $scope.startDate = start.format('YYYY-01-01[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-12-31[T]23:59:59.999[Z]')
      else
        $scope.month = $scope.selected.clone()
        start = $scope.selected.clone()
        start.date 1
        removeTime(start.day(0))
        end = $scope.selected.clone()
        end.date(lastDay)
        removeTime(end.day(7))

        $scope.startDate = start.toISOString()
        $scope.endDate = end.toISOString()

    fetchData()
  $scope.next = ->
    switch $scope.view
      when 'day'
        prevDay = $scope.selected.clone()
        $scope.selected.date $scope.selected.date() + 1
        start = $scope.selected.clone()
        end = $scope.selected.clone()

        if prevDay.month() != $scope.selected.month()
          changeMonth()

        $scope.startDate = start.format('YYYY-MM-DD[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-MM-DD[T]23:59:59.999[Z]')

        if prevDay.year() != $scope.selected.year()
          $scope.changeYear = true
          nextyr = $scope.year.clone()
          nextyr.year(nextyr.year() + 1)
          $scope.year.year $scope.year.year() + 1
          startY = $scope.year.clone()
          endY = $scope.year.clone()
          $scope.months = Array.apply(0, Array(12)).map (_, i) ->
            moment(nextyr).month(i)

          $scope.startDate = startY.format('YYYY-01-01[T]00:00:00.000[Z]')
          $scope.endDate = endY.format('YYYY-12-31[T]23:59:59.999[Z]')
      when 'year'
        nextyr = $scope.year.clone()
        nextyr.year(nextyr.year() + 1)
        $scope.year.year $scope.year.year() + 1
        start = $scope.year.clone()
        end = $scope.year.clone()
        $scope.startDate = start.format('YYYY-01-01[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-12-31[T]23:59:59.999[Z]')
        $scope.months = Array.apply(0, Array(12)).map (_, i) ->
          moment(nextyr).month(i)
      else
        start = $scope.month.clone()
        start.month(start.month() + 1).date 1
        removeTime start.day(0)
        $scope.startDate = start.toISOString()
        end = $scope.month.clone()
        end.month(end.month() + 1).date(lastDay)
        removeTime end.day(7)
        $scope.endDate = end.toISOString()

        $scope.month.month $scope.month.month() + 1
    fetchData()

  $scope.prev = ->
    switch $scope.view
      when 'day'
        prevDay = $scope.selected.clone()
        $scope.selected.date $scope.selected.date() - 1
        start = $scope.selected.clone()
        end = $scope.selected.clone()

        if prevDay.month() != $scope.selected.month()
          changeMonth()

        $scope.startDate = start.format('YYYY-MM-DD[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-MM-DD[T]23:59:59.999[Z]')

        if prevDay.year() != $scope.selected.year()
          $scope.changeYear = true
          prevyr = $scope.year.clone()
          prevyr.year(prevyr.year())
          $scope.year.year $scope.year.year() - 1
          startY = $scope.year.clone()
          endY = $scope.year.clone()
          $scope.startDate = start.format('YYYY-01-01[T]00:00:00.000[Z]')
          $scope.endDate = end.format('YYYY-12-31[T]23:59:59.999[Z]')
          $scope.months = Array.apply(0, Array(12)).map (_, i) ->
            moment(start).month(i)

          $scope.startDate = startY.format('YYYY-01-01[T]00:00:00.000[Z]')
          $scope.endDate = endY.format('YYYY-12-31[T]23:59:59.999[Z]')
      when 'year'
        prevyr = $scope.year.clone()
        prevyr.year(prevyr.year())
        $scope.year.year $scope.year.year() - 1
        start = $scope.year.clone()
        end = $scope.year.clone()
        $scope.startDate = start.format('YYYY-01-01[T]00:00:00.000[Z]')
        $scope.endDate = end.format('YYYY-12-31[T]23:59:59.999[Z]')
        $scope.months = Array.apply(0, Array(12)).map (_, i) ->
          moment(start).month(i)
      else
        start = $scope.month.clone()
        start.month(start.month() - 1).date 1
        removeTime start.day(0)
        $scope.startDate = start.toISOString()
        end = $scope.month.clone()
        end.month(end.month() - 1).date(lastDay)
        removeTime end.day(7)
        $scope.endDate = end.toISOString()

        $scope.month.month $scope.month.month() - 1
    fetchData()

  $scope.recordCount =(record)->
    record.reduce ((prevVal, elem) ->
      Object.keys(elem).forEach (key, index) ->
        console.log elem[key].record_count
    ), 0

  $scope.currentDayRecord =(record)->
    initVal = {record_count: 0, data: []}
    found = initVal
    record.reduce ((prevVal, elem) ->
      if elem[$scope.selected.format("DD.MM.YYYY")]
        found = elem[$scope.selected.format("DD.MM.YYYY")]
      return found
    ), initVal

angular.module('client').controller('UserCalendarCtrl', Ctrl)