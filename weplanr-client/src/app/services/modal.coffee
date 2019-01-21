module =($rootScope,Session)->
  modals = []
  service = {}

  Add = (modal) ->
    modals.push modal
    return

  Remove = (id) ->
    modalToRemove = _.find(modals, id: id)
    modals = _.without(modals, modalToRemove)
    return

  Open = (id, type='generic') ->
    $rootScope.regType = type
    modal = _.find(modals, id: id)
    modal.state = true
    modal.open()
    return

  Close = (id) ->
    modal = _.find(modals, id: id)
    modal.state = false
    modal.close()
    return

  GalleryOpen = (id, cnt) ->
    $rootScope.slideCurrent = cnt
    modal = _.find(modals, id: id)
    modal.state = true
    modal.galleryOpen()
    return

  GalleryClose = (id) ->
    modal = _.find(modals, id: id)
    modal.state = false
    modal.galleryClose()
    return

  CheckState = (id) ->
    obj = modals.filter (obj) ->
      obj.state == true
    return obj.length

  service.Add = Add
  service.Remove = Remove
  service.Open = Open
  service.Close = Close
  service.CheckState = CheckState
  service.GalleryClose = GalleryClose
  service.GalleryOpen = GalleryOpen
  service

angular.module('client').factory('ModalService', module)
