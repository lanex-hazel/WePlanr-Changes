angular.module('client').directive "calendarDashboard", (Vendor)->
  restrict: "E"
  templateUrl: 'app/components/calendar_dashboard/index.html'
  scope:
    vendorId: "="

  link: (scope, element, attrs) ->
    scope.loaded = true
    scope.bookings =  []
    scope.closed = []
    scope.fullybooked = []
    scope.getCalendarEvents =(date)->
      scope.loaded = false
      Vendor.getEvents(id: scope.vendorId, date: date.format('YYYY-MM-DD')).$promise.then (res)->
        scope.loaded = true
        scope.bookings =  res.data.bookings
        scope.closed = res.data.closed
        scope.fullybooked = res.data.fullybooked

    removeTime = (date) ->
      date.day(0).hour(0).minute(0).second(0).millisecond 0

    buildMonth = (scope, start, month) ->
      scope.weeks = []
      done = false
      date = start.clone()
      monthIndex = date.month()
      count = 0
      while !done
        scope.weeks.push days: buildWeek(date.clone(), month)
        date.add 1, 'w'
        done = count++ > 2 and monthIndex != date.month()
        monthIndex = date.month()
      return

    buildWeek = (date, month) ->
      days = []
      i = 0
      while i < 7
        days.push
          name: date.format('dd').substring(0, 1)
          number: date.date()
          isCurrentMonth: date.month() == month.month()
          isToday: date.isSame(new Date, 'day')
          date: date
          isUnavailable: scope.fullybooked.includes(date.format('YYYY-MM-DD'))
          isClosed: scope.closed.includes(date.format('YYYY-MM-DD'))
          isBookedYr: scope.bookings.includes(date.format('YYYY-MM-DD'))
        date = date.clone()
        date.add 1, 'd'
        i++
      days


    scope.selected = removeTime(moment())
    scope.month = scope.selected.clone()
    start = scope.selected.clone()
    start.date 1
    removeTime start.day(0)
    currentBuild = start
    scope.$watch 'vendorId', (val)->
      scope.getCalendarEvents(scope.selected) if val?
    scope.$watch 'loaded', (val)->
      buildMonth scope, currentBuild, scope.month if val?

    scope.next = ->
      next = scope.month.clone()
      next.month(next.month() + 1).date 1
      removeTime next.day(0)
      scope.month.month scope.month.month() + 1
      currentBuild = next
      scope.getCalendarEvents(scope.month)
      return

    scope.previous = ->
      previous = scope.month.clone()
      removeTime previous.month(previous.month() - 1).date(1)
      scope.month.month scope.month.month() - 1
      currentBuild = previous
      scope.getCalendarEvents(scope.month)
      return

    scope.getStatus =(status)->
      if status.isClosed
        return 'Closed'
      else if status.isUnavailable
        return 'Fully Booked'
      else if status.isBookedYr
        return 'Partially Booked'
      else
        return 'Available'



    return