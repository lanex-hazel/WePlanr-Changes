angular.module('client').directive 'countdownClock', [ '$interval'
($interval) ->
  restrict: "E"
  templateUrl: 'app/components/countdown_clock/index.html'
  scope:
    date: "<"
  link: (scope, element, attrs) ->


    scope.$watch 'date', (val) ->
      if val
        scope.date_diff = {}
        scope.today = moment(moment().format('YYYY-MM-DD'))
        scope.now = moment(moment().format('YYYY-MM-DD HH:mm:ss'))
        scope.end =
          if val < scope.today._i
            moment(moment().format('YYYY-MM-DD HH:mm:ss'))
          else
            moment(moment(val).format('YYYY-MM-DD 00:00:00'))

        updateTime()

        scope.stopTime = $interval ( ->
            scope.today = moment(moment().format('YYYY-MM-DD'))
            scope.now = moment(moment().format('YYYY-MM-DD HH:mm:ss'))
            updateTime()
          ), 1000

    updateTime = ->
      distance = scope.end._d.getTime() - scope.now._d.getTime()
      month =  scope.end.diff(scope.today, 'months')
      scope.today.add(month, 'months')
      scope.date_diff =
        months: ("0" + month).slice(-2),
        days: ("0" + scope.end.diff(scope.today, 'days')).slice(-2),
        hours:("0" + Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))).slice(-2)
      $interval.cancel(scope.stopTime) if distance < 0

]