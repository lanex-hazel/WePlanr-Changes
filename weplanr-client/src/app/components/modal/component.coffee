angular.module('client').directive 'modal', (ModalService) ->

  link: (scope, element, attrs) ->

    Open = ->
      selectElem.show()
      $('body').addClass('modal-open')

    Close = ->
      selectElem.find('form')[0].reset() if selectElem.find('form')[0]
      if scope.registerForm?
        form =  scope.registerForm
      else
        form = scope.loginform
      if !!form
        keys = Object.keys(form)
        controlNames = Object.keys(form).filter (key) -> key.indexOf('$') != 0

        for name in controlNames
          control = form[name]
          control.$setViewValue(undefined)

        form.$setPristine()
        form.$setUntouched()

        scope.uiState.registered = false
        scope.uiState.error = ''
        scope.email_sent = false

      selectElem.hide()
      $('body').removeClass('modal-open')

    GalleryOpen = ->
      selectElem.show()
      $('body').addClass('modal-open')

    GalleryClose = ->
      selectElem.hide()
      $('body').removeClass('modal-open')

    console.error 'modal must have an id' if !attrs.id
    selectElem = angular.element(element[0])
    selectElem.appendTo('body')
    selectElem.on 'click', (evt) ->
      target = $(evt.target)
      if !target.closest('.modal-body').length
        scope.$evalAsync(Close)
      if !!target.closest('.carousel-item').length
        scope.$evalAsync(GalleryClose)

    modal =
      id: attrs.id
      open: Open
      close: Close
      state: false
      galleryOpen: GalleryOpen
      galleryClose: GalleryClose
    ModalService.Add(modal)

    scope.$on '$destroy', ->
      ModalService.Remove(attrs.id)
      selectElem.remove()
