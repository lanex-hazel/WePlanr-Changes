angular.module('client').directive 'datePicker', ->
  restrict: "A"
  scope:
    config: "=dateRangePicker"
    start: "=start"
    end: "=end"
    minDate: "=minDate"
    maxDate: "=maxDate"
    modelValue: '=ngModel'
    singlePicker: "="
    limitLegalAge: "<"
    preventToday: "<"
    format: "="
    callback: '&ngChange'

  link: ($scope, $element, $attrs) ->
    pickerElement = angular.element($element[0])
    pickerElement.parent().append("<i class='clickable-calendar fa fa-calendar'></i>")
    defaultConfig =
      opens: "left"
      autoApply: true
      autoUpdateInput: false
      minDate: $scope.minDate
      maxDate: $scope.maxDate
      singleDatePicker: !!$scope.singlePicker
      showDropdowns: !!$scope.singlePicker
      locale:
        format: 'DD/MM/YY'

    if $scope.limitLegalAge
      defaultConfig.maxDate = moment().add("years",-18).add("days",-1)
    if $scope.preventToday
      defaultConfig.minDate = moment().add("days", 1)
    if $scope.format
      defaultConfig.locale.format = $scope.format

    config = if $scope.config then angular.extend($scope.config, defaultConfig) else defaultConfig
    pickerElement.daterangepicker config, (chosenDate)->
      $scope.callback() if $scope.callback and not config.autoUpdateInput

    if config.singleDatePicker
      if !!$scope.modelValue
        pickerElement.data('daterangepicker').setStartDate(moment($scope.modelValue, config.locale.format))
        pickerElement.data('daterangepicker').setEndDate(moment($scope.modelValue, config.locale.format))
      pickerElement.on 'apply.daterangepicker', (e, picker) ->
        $scope.modelValue = picker.startDate.format(config.locale.format)
        $scope.$apply()
        pickerElement.val($scope.modelValue)
    else
      pickerElement.on 'show.daterangepicker', (e, picker) ->
        if $scope.start && $scope.end
          picker.setStartDate($scope.start)
          picker.setEndDate($scope.end)
          picker.renderCalendar('left')
          picker.renderCalendar('right')

    $(document).on 'click', '.clickable-calendar ', ->
      $(this).parent().find('input').click()
      return

    return
