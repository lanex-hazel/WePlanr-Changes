Ctrl =($scope,$timeout)->

  ctrl = this

  ctrl.$onInit = ->
    @.fieldId = if !!ctrl.fieldId then ctrl.fieldId else ""
    @.fieldPlaceholder = if !!ctrl.fieldPlaceholder then ctrl.fieldPlaceholder else ctrl.fieldName

  $timeout ->
    autocomplete = new google.maps.places.Autocomplete(document.getElementById(ctrl.fieldId))
    autocomplete.addListener 'place_changed', ->
      ctrl.fieldValue = autocomplete.getPlace().name
      ctrl.fieldGeolat = autocomplete.getPlace().geometry.location.lat()
      ctrl.fieldGeolng = autocomplete.getPlace().geometry.location.lng()
      $scope.$apply()

  return

angular.module('client').component 'formAddress',
  templateUrl: 'app/components/input_address/index.html'
  controller: Ctrl
  bindings:
    fieldValue: "="
    fieldId: "@?"
    fieldPlaceholder: "@?"
    getGeo: "@"
    fieldGeolat: "="
    fieldGeolng: "="