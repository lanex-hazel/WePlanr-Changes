angular.module('client').directive 'calendarDay',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/day.html'

angular.module('client').directive 'calendarMonth',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/month.html'

angular.module('client').directive 'calendarYear',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/year.html'


angular.module('client').directive 'bookingEditForm',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/edit_form.html'

angular.module('client').directive 'bookingAddForm',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/add_form.html'

angular.module('client').directive 'mobileCalendarDay',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/mobile_day.html'

angular.module('client').directive 'mobileCalendarMonth',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/mobile_month.html'

angular.module('client').directive 'mobileCalendarYear',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/vendor/calendar/partials/mobile_year.html'
