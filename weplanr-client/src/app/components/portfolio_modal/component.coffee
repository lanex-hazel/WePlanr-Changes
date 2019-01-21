Ctrl =(ModalService,$window,$timeout,$interval,$rootScope,$scope)->
  ctrl = this

  ctrl.$onInit = ->
    @.currentSlide = 0
    @.ellipsis = 0
    @.condition = @.currentSlide < 4

  alignedImgs = []
  realign = ->
    return unless ctrl.photos
    ((img)->
      $timeout ->
        img.one('load', ->
          imgWidth = img.width()
          imgHeight = img.height()
          return if imgWidth is 0 or imgHeight is 0

          containerHeight = $('#small-slideshow').parent().position().top - $('#slideshow-container').position().top # get content height
          screenWidth = $('#slideshow').width()

          if imgWidth >= screenWidth # if img width not fit on screen width
            img.css('width', 'calc(100% - 6px)') # fit img to full width

          spacingAllowance = 30 # px
          if (img.height() + spacingAllowance) >= containerHeight # if img height not fit on containerHeight
            heightPct = containerHeight / img.height()
            newHeight = heightPct * img.height() - spacingAllowance
            img.css('height', "#{newHeight}px")
            img.css('width', 'auto')

          imgMarginTop = Math.max.apply(null, [0, ($('portfolio-modal .icon-arrow-left').position().top - (img.height() / 2))])
          if imgMarginTop + img.height() > containerHeight
            imgMarginTop = Math.max.apply(null, [0, ((containerHeight / 2) - (img.height() / 2))])
          img.css('margin-top', "#{imgMarginTop}px")

          $('.exit-modal')
            .css('right', "calc(50% + 50px - #{img.width() / 2}px)")
            .css('top', "calc(#{imgMarginTop}px + 1rem)")

        ).each ->
          if img.height() > 0
            img.trigger('load')
          else
            looper = $interval ->
              if img.height() > 0
                img.trigger('load')
              else
                $interval.cancel(looper)
            , 500
    )($("#portfolio-modal .carousel-item img[src$='#{ctrl.photos[ctrl.currentSlide].url}']"))

  ctrl.nextSlide = ->
    ctrl.itemWidth = ctrl.carousel.find('li:first').width()
    if @.currentSlide < @.count-1
      @.currentSlide += 1
      ctrl.carousel.animate { scrollLeft: '+=' + ctrl.itemWidth }, 300
    else
      @.currentSlide = 0
      ctrl.carousel.animate { scrollLeft: '0' }, 300
    realign()

  ctrl.prevSlide = ->
    ctrl.itemWidth = ctrl.carousel.find('li:first').width()
    if @.currentSlide == 0
      @.currentSlide = @.count-1
      ctrl.carousel.animate { scrollLeft: ctrl.carousel.width() * 2 + 100 }, 300
    else
      @.currentSlide -=1
      ctrl.carousel.animate { scrollLeft: '-=' + ctrl.itemWidth }, 300
    realign()

  ctrl.closeModal = ->
    ModalService.GalleryClose('portfolio-modal')

  ctrl.display =(val)->
    if @.currentSlide < 4
      @.condition = val < 4
    else if @.currentSlide > 7
      @.condition = val > 7
    else
      @.condition = val >= 4 && val <= 7
    @.condition

  ctrl.setSlideIndex = (idx)->
    ctrl.currentSlide = idx
    realign()

  $timeout ->
    ctrl.carousel = $('#small-slideshow')

    $scope.$watch '$root.slideCurrent', (value) ->
      ctrl.currentSlide = if value then value else 0
      ctrl.itemWidth = ctrl.carousel.find('li:first').width() * value
      ctrl.carousel.animate { scrollLeft: '+=' + ctrl.itemWidth }, 300
      realign()


  return


angular.module('client').component 'portfolioModal',
  templateUrl: 'app/components/portfolio_modal/index.html'
  controller: Ctrl
  bindings:
    caption: "<"
    photos: "="
    count: "="
