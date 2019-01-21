Ctrl = ->
  ctrl = this

  parseNum = (val)->
    strNum = String(val).replace(/[\D\s]+/g, '')
    Number(strNum)

  ctrl.$onInit = ->
    @.edit = false
    @.budget = 0

  ctrl.submit = ->
    if @.budget != @.maxBudget && !!@.maxBudget
      swal(RECALCULATE_BUDGET_PLANNED).then (isConfirm) ->
        if isConfirm
          ctrl.maxBudget = parseNum(ctrl.maxBudget)
          ctrl.save({budget: ctrl.maxBudget})
          ctrl.edit = false

  ctrl.toggle =(edit)->
    if edit
      @.edit = edit
      @.budget = angular.copy @.maxBudget
    else
      @.edit = edit
      @.maxBudget = @.budget

  ctrl.setWidth =(num)->
    return ((num/@.maxBudget)*192)

  return

angular.module('client').component 'organisrOverview',
  templateUrl: 'app/components/organisr_overview/index.html'
  controller: Ctrl
  bindings:
    removeModal: "="
    maxBudget: "="
    planned: "<"
    actual: "<"
    save: "&"