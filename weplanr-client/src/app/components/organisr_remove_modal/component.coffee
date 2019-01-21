Ctrl = ->
  ctrl = this

  ctrl.submit = ->
    @.remove({obj:@.obj})
    @.removeModal = false
    @.obj = null

  return

angular.module('client').component 'organisrRemoveModal',
  templateUrl: 'app/components/organisr_remove_modal/index.html'
  controller: Ctrl
  bindings:
    obj: "<"
    removeModal: "="
    remove: "&"