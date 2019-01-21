angular.module('client').directive "eventCalendar", ($timeout, Booking)->
  restrict: "E"
  templateUrl: 'app/components/event_calendar/index.html'
  scope:
    yrrange: "="
    view: "="
    booked: "="
    bookedDays: "="
    bookedDates: "="
    eventTime: "="
    hasEvent: "="
    unavailableDates: "="
    closedDates: "="
    sel: "="
    state: "="
    save: "&"
    remove: "&"
    update: "&"
    getBookings: "&"
    blockDate: "&"
    unblockDate: "&"

  link: (scope, element, attrs) ->

    scope.currentDay = moment()
    scope.form =
      schedule: ''
      client: ''
      location: ''
      details: ''
      time: ''
    scope.currentTab = 0
    scope.temp = ''
    scope.monthrange = []

    scope.$watch 'view', (value, old)->
      if value == 'year'
        scope.getBookings({date:scope.sel.curYear})
      else if value == 'day'
        scope.getBookings({date:scope.sel.curDay})
      else
        scope.getBookings({date: scope.month.format('YYYY-MM-DD')})

    scope.$watch '[state.add, state.failUpd]', (values) ->
      resetForm() if !values[0] || !values[1]

    scope.changeTab =(tab)->
      scope.currentTab = tab

    scope.formatSched = (dateStr)->
      moment(dateStr, 'DD.MM.YYYY').format('DD MMM YYYY')

    scope.changeView =(view,day=null)->
      if day?
        scope.sel.curDay = day
        scope.currentDay = moment(day)
      if scope.view != view
        scope.view = view
      else if scope.view == view
        scope.getBookings({date:scope.sel.curDay})

    scope.onCancel = ->
      scope.state.add = false

    scope.toggleEdit =(isEdit)->
      if isEdit
        scope.state.edit = true
        scope.temp = angular.copy(scope.bookedDays[scope.currentTab])
      else
        scope.state.edit = false
        scope.bookedDays[scope.currentTab] = scope.temp

    scope.onEdit =(obj)->
      scope.update({obj:obj})

    scope.onDelete =(obj,day)->
      scope.remove({obj: obj, day: day.format('YYYY-MM-DD')})
      scope.currentTab = 0

    scope.onBook =(form, currentDay)->
      resetForm() if !scope.hasEvent && !scope.state.add
      scope.save({obj:form, day: currentDay})
      scope.state.add = false

    scope.setBlock =(day,type)->
      scope.blockDate({day: day.format('YYYY-MM-DD'),type:type})

    scope.unsetBlock =(type)->
      idx = if type == 'closed' then scope.close_index else scope.unavailable_index
      scope.unblockDate({index: idx ,type:type})

    scope.isBlocked =(day)->
      if day?
        scope.unavailable_index = scope.unavailableDates.indexOf(day.format('YYYY-MM-DD'))
        scope.unavailable_index > -1

    scope.isClosed =(day)->
      if day? && scope.closedDates?
        scope.close_index = scope.closedDates.indexOf(day.format('YYYY-MM-DD'))
        scope.close_index > -1

    resetForm = ->
      scope.form =
        schedule: ''
        client: ''
        location: ''
        details: ''
        time: ''
      angular.element($('input.timepicker')[0]).val('')

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
        index = null
        found = scope.booked.some (el) ->
          if el.event_date == date.format('DD.MM.YYYY')
            index = scope.booked.indexOf el
          el.event_date == date.format('DD.MM.YYYY')
        days.push
          name: date.format('dd').substring(0, 1)
          number: date.date()
          isCurrentMonth: date.month() == month.month()
          date: date
          isBooked: found
          noOfBookings: scope.booked[index].bookings if index?
          isUnavailable: scope.unavailableDates.indexOf(date.format('YYYY-MM-DD')) > -1
          isClosed: scope.closedDates.indexOf(date.format('YYYY-MM-DD')) > -1
          isToday: date.isSame(new Date(), "day")
        scope.booked[index].isCurrentMonth = days[i].isCurrentMonth  if index?
        date = date.clone()
        date.add 1, 'd'
        i++
      days

    scope.$watch '[state.bookingLoaded,state.blockdatesLoaded]', (values) ->
      if (values[0] && values[1])
        scope.months = []
        if scope.view == 'year' && currentBuild != 'nav'
          for r in scope.yrrange
            scope.year = moment(r).clone()
            month = moment(r).clone()
            start =  moment(r).clone()
            start.date 1
            removeTime(start.day(0))
            buildMonth scope, start, month
            scope.months.push {year: start.year(),month: month.format('MMMM'), weeks: scope.weeks}
          $timeout ->
            id = "##{scope.month.format('MMMM')}"
            $('html, body').animate { scrollTop: $(id).offset().top - 45}, 1000
        else if scope.view == 'year' && currentBuild == 'nav'
          for r in scope.monthrange
            month = moment(r).clone()
            start =  moment(r).clone()
            start.date 1
            removeTime start.day(0)
            buildMonth scope, start, month
            scope.months.push {year: scope.sel.curYear ,month: month.format('MMMM'), weeks: scope.weeks}
        else
          start = scope.month.clone()
          start.date 1
          removeTime(start.day(0))
          buildMonth scope, start, scope.month

      $timeout ->
        $('input.timepicker').timepicker
          timeFormat: 'HH:mm'
          interval: 30
          minHour: 0
          maxHour: 24
          defaultHour: 0
          startHour: 0
          dynamic: false
          dropdown: true
          scrollbar: true
          change: (time)->
            element = $(this)
            timepicker = element.timepicker()
            scope.form.schedule = scope.currentDay.format('YYYY-MM-DD ') + timepicker.format(time)
            moment().format('MMMM Do YYYY, h:mm:ss a')
        $('input.edit-timepicker').timepicker
          timeFormat: 'HH:mm'
          interval: 30
          minHour: 0
          maxHour: 24
          defaultHour: 0
          startHour: 0
          dynamic: false
          dropdown: true
          scrollbar: true
          change: (time)->
            element = $(this)
            timepicker = element.timepicker()
            scope.bookedDays[scope.currentTab].attributes.schedule = scope.currentDay.format('YYYY-MM-DD ') + timepicker.format(time)
            scope.bookedDays[scope.currentTab].attributes.schedule_time = timepicker.format(time)
            scope.$apply()
    
    scope.months = []

    scope.selected = moment()
    scope.month = scope.selected.clone()
    start = scope.selected.clone()
    start.date 1
    removeTime(start.day(0))
    currentBuild = start

    scope.next = ->
      next = scope.month.clone()
      next.month(next.month() + 1).date 1
      removeTime next.day(0)
      scope.month.month scope.month.month() + 1
      currentBuild = next
      scope.getBookings({date:scope.month.format('YYYY-MM-DD')})
      return

    scope.nextday = ->
      scope.currentDay.date scope.currentDay.date() + 1
      scope.sel.curDay = scope.currentDay.format('YYYY-MM-DD')
      scope.getBookings({date:scope.currentDay.format('YYYY-MM-DD')})
      scope.currentTab = 0

    scope.nextyear = ->
      currentBuild = 'nav'
      nextyr = scope.year.clone()
      nextyr.year(nextyr.year() + 1)
      scope.year.year scope.year.year() + 1
      scope.sel.curYear = nextyr.year()
      scope.getBookings(date:nextyr.year())

      scope.monthrange = Array.apply(0, Array(12)).map (_, i) ->
        nextyr.month(i).format 'YYYY-MM-DD'
      scope.months = []

    scope.previous = ->
      previous = scope.month.clone()
      removeTime previous.month(previous.month() - 1).date(1)
      scope.month.month scope.month.month() - 1
      currentBuild = previous
      scope.getBookings({date:scope.month.format('YYYY-MM-DD')})

    scope.previousday = ->
      scope.currentDay.date scope.currentDay.date() - 1
      scope.sel.curDay = scope.currentDay.format('YYYY-MM-DD')
      scope.getBookings({date:scope.currentDay.format('YYYY-MM-DD')})
      scope.currentTab = 0

    scope.prevyear = ->
      currentBuild = 'nav'
      prevyr = scope.year.clone()
      prevyr.year(prevyr.year() - 1)
      scope.year.year scope.year.year() - 1
      scope.sel.curYear = prevyr.year()
      scope.getBookings(date:prevyr.year())
      scope.monthrange = Array.apply(0, Array(12)).map (_, i) ->
        prevyr.month(i).format 'YYYY-MM-DD'
      scope.months = []
