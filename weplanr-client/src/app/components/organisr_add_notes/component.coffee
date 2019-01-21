Ctrl =($interval,$scope,$timeout)->
  ctrl = this

  ctrl.$onInit = ->
    @.formInvalid = false
    @.note = angular.copy(@.obj.attributes.notes)
    @.saved = false
    @.timeout = null

  ctrl.submit = ->
    type = 'Todo'
    type = 'CustomTodo' if @.obj.type == 'Organisr::CustomTodo'
    params =
      noteable_type: type
      content: @.note
    if @.save({obj: @.obj, params: params})
      @.saved = true
    else
      @.saved = false

  ctrl.parseNum = (val)->
    strNum = String(val).replace(/[\D\s]+/g, '')
    Number(strNum)


  $scope.$watch '$ctrl.note', (newval, oldval)->
    if newval != oldval
      $timeout((-> ctrl.submit()), 5000) unless ctrl.saved

  $scope.$watch '$ctrl.saved', (newval) ->
    if newval
      $timeout((-> ctrl.saved = false), 5000)

  return

angular.module('client').component 'organisrAddNotes',
  templateUrl: 'app/components/organisr_add_notes/index.html'
  controller: Ctrl
  bindings:
    toggleForm: "&"
    save: "&"
    obj: "="