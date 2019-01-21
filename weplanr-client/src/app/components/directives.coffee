angular.module('client').directive 'contentAdjust', ->
  link: (scope, elem, attrs) ->

    scope.$watch attrs.ngModel, (newvalue) ->
      contentElement = document.getElementById('aboutcontent')
      scrollHeight = contentElement.scrollHeight
      contentElement.style.height =  scrollHeight + "px"
      contentElement.style.height = "37px" if newvalue == ""

    elem.bind 'change paste cut click',  ->
      scope.$apply ->
        contentElement = document.getElementById('aboutcontent')
        scrollHeight = contentElement.scrollHeight
        contentElement.style.height =  scrollHeight + "px"

angular.module('client').directive 'autoScroll', ->
  link: (scope, elem, attrs) ->
    elem.bind 'click',  ->
      $('html, body').animate { scrollTop: $(attrs.page).offset().top }, 500

angular.module('client').directive 'myUiSelect', ->
  require: 'uiSelect',
  link: (scope, elem, attrs, $select) ->
    tags = scope.query.services
    select = $select
    scope.$watch 'services', (newvalue) ->
      tags =
        if typeof scope.query.services == 'string'
          scope.query.services.split(",")
        else
          scope.query.services
      select = $select
      if newvalue? && tags?
        for service in newvalue
          is_same = service.attributes.tags.length == tags.length && service.attributes.tags.every (element,index) -> element == tags[index]
          if is_same
            select.selected = service
            scope.keywords.services = service.attributes.name

angular.module('client').directive 'equalizeHeight', [
  '$timeout'
  ($timeout) ->
    {
      restrict: 'A'
      controller: ($scope) ->
        elements = []

        @addElement = (element) ->
          elements.push element
          return

        # resize elements once the last element is found
        @resize = ->
          $timeout (->
            # find the tallest
            tallest = 0
            height = undefined
            angular.forEach elements, (el) ->
              height = el[0].offsetHeight
              if height > tallest
                tallest = height
              return
            # resize
            angular.forEach elements, (el) ->
              el[0].style.height = tallest + 'px'
              return
            return
          ), 0
          return

        return

    }
]

angular.module('client').directive 'equalizeHeightAdd', [ ($timeout) ->
  {
    restrict: 'A'
    require: '^^equalizeHeight'
    link: (scope, element, attrs, ctrl_for) ->
      # add element to list of elements
      ctrl_for.addElement element
      if scope.$last
        ctrl_for.resize()
      return

  }
]


separateNumbers = (val)->
  return '0' unless val
  strNum = String(val).replace(/[\D\s]+/g, '')
  Number(strNum).toLocaleString('ru-RU')
angular.module('client').directive 'spacedNumbers', ->
  {
    restrict: 'A'
    require: '?ngModel'
    scope:
      numberDelimeter: '@'
    link: (scope, elem, attrs, ctrl) ->
      ctrl.$formatters.unshift (_) ->
        separateNumbers ctrl.$modelValue
      ctrl.$parsers.unshift (val) ->
        newVal = if val then separateNumbers(val) else val
        elem.val newVal
        newVal
  }


angular.module('client').directive 'prefixedSpacedNumbers', [
  ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, elem, attrs, ctrl) ->
      return unless ctrl
      ctrl.$formatters.unshift (_) ->
        newVal = separateNumbers ctrl.$modelValue
        if Number(newVal) is 0
          newVal
        else
          "$ #{newVal}"
      ctrl.$parsers.unshift (val) ->
        newVal = separateNumbers(val)
        if Number(newVal) isnt 0
          newVal = "$ #{newVal}"
        elem.val newVal
        newVal
]

angular.module('client').directive 'formGeoaddress', [
  '$timeout'
  ($timeout) ->
    restrict: 'A'
    scope:
      address: "="
    link: (scope, elem, attrs) ->

      $timeout ->
        inputElem = elem[0]
        autocomplete = new google.maps.places.Autocomplete(inputElem)
        autocomplete.addListener 'place_changed', ->
          scope.address = autocomplete.getPlace().name
          scope.$apply()
]

angular.module('client').directive 'abnFormat', [
  '$timeout'
  ($timeout) ->
    restrict: 'A'
    require: '?ngModel'
    scope:
      number: "="
    link: (scope, elem, attrs, ctrl) ->
      $timeout ->
        inputElem = elem[0]
        ctrl.$formatters.unshift (_) ->
          ctrl.$modelValue.toString().split('').reverse().join('').replace(/(.{1,3})/g, '$1 ').trim().split('').reverse().join('') if ctrl.$modelValue?
        ctrl.$parsers.unshift (val) ->
          val = val.replace(/\s+/g, '')
          newVal = val.toString().split('').reverse().join('').replace(/(.{1,3})/g, '$1 ').trim().split('').reverse().join('') if val?
          elem.val newVal
          newVal
]

NUMBER_KEYS = [48,49,50,51,52,53,54,55,56,57]
DOT_KEYS = [190]
DELETE_KEYS = [8,46]
ARROW_KEYS = [37,38,39,40]
DECIMAL_KEYS = NUMBER_KEYS.concat(DOT_KEYS).concat(DELETE_KEYS).concat(ARROW_KEYS)
angular.module('client').directive 'decimalOnly', ->
  restrict: 'A'
  require: '?ngModel'
  link: (scope, elem, attrs) ->
    elem.bind 'keydown', (event)->
      event.preventDefault() unless event.which in DECIMAL_KEYS

INTEGER_KEYS = NUMBER_KEYS.concat(DELETE_KEYS).concat(ARROW_KEYS)
angular.module('client').directive 'integerOnly', ->
  restrict: 'A'
  require: '?ngModel'
  link: (scope, elem, attrs) ->
    elem.bind 'keydown', (event)->
      event.preventDefault() unless event.which in INTEGER_KEYS

SLASH_KEYS = [191]
DATE_KEYS = NUMBER_KEYS.concat(DELETE_KEYS).concat(SLASH_KEYS)
angular.module('client').directive 'dateOnly', ->
  restrict: 'A'
  require: '?ngModel'
  link: (scope, elem, attrs) ->
    elem.bind 'keydown', (event)->
      event.preventDefault() unless event.which in DATE_KEYS

angular.module('client').directive 'ngFormat', [
  '$filter'
  ($filter) ->
    require: '?ngModel'
    link: (scope, elem, attrs, ctrl) ->
      return unless ctrl
      ctrl.$formatters.unshift (a) ->
        filter = attrs.ngFormat.split(':')
        $filter(filter.shift()).apply null, [ctrl.$modelValue].concat(filter)
      elem.bind 'blur', (event) ->
        filter = attrs.ngFormat.split(':')
        val =
          if filter[0] is 'currency'
            elem.val().replace(/[^\d|\-+|\.+]/g, '')
          else
            ctrl.$modelValue
        elem.val $filter(filter.shift()).apply null, [val].concat(filter)
]

angular.module('client').directive 'headerScroll', ($window) ->
  (scope, element, attrs) ->
    angular.element($window).bind 'scroll', ->
      if @pageYOffset >= 59
        scope.showBurgerMenu = true
      else
        scope.showBurgerMenu = false
      scope.$apply()

angular.module('client').directive 'loadScroll', ->
  (scope, element, attrs) ->
    angular.element(element).bind 'scroll', ->
      if(@offsetHeight + @scrollTop == @scrollHeight)
        scope.loadMore()
      scope.$apply()

angular.module('client').directive 'enterSubmit', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.bind 'keydown', (event) ->
      code = event.keyCode or event.which
      if code == 13
        if !event.shiftKey
          event.preventDefault()
          scope.$apply attrs.enterSubmit