Ctrl =($scope,$rootScope,$state,$interval,$timeout,$window,ModalService,Session,Gmap,Vendor)->
  ctrl = this

  ctrl.$onInit = ->
    @.maxRating = [1,2,3,4,5]
    @.rate = 3
    @.showState =
      about: false
      more: false
      services: false
      location: @.showLocation
      packages: false
    @.process = false
    @.currentSlide = 0
    $rootScope.backProfile = false
    if @.showLocation
      @.showState.more = true
      $timeout ->
        ctrl.mapOut()

  $scope.$watch '$ctrl.vendor', (val) ->
    if !!val
      ctrl.locations = _.union(ctrl.vendor.locations, ctrl.vendor.other_locations)
      ctrl.services = Vendor.allServices(ctrl.vendor)

  ctrl.openModal =(id,flag)->
    Session.setRegisterEvent({current_state: 'enquiry', vendor_id: $state.params.id})
    ModalService.Open(id,'signupb')

  ctrl.openGallery =(slide=0)->
    ModalService.GalleryOpen('portfolio-modal', slide)

  ctrl.composeMsg = ->
    Session.set 'composeForVendor', ctrl.vendor
    $state.go 'user.messages'

  ctrl.toggle =(state)->
    if state then @.nextSlide() else @.prevSlide()

  ctrl.nextSlide = ->
    len = @.vendor.photo_urls.length - 1
    carousel = $('#portfolio-slideshow')
    ctrl.itemWidth = carousel.find('li:first').width()
    if @.currentSlide < len
      @.currentSlide += 1
      carousel.animate { scrollLeft: '+=' + ctrl.itemWidth }, 300
    else
      @.currentSlide = 0
      carousel.animate { scrollLeft: '0' }, 300

  ctrl.prevSlide = ->
    len = @.vendor.photo_urls.length - 1
    carousel = $('#portfolio-slideshow')
    ctrl.itemWidth = carousel.find('li:first').width()
    if @.currentSlide == 0
      @.currentSlide = len
      carousel.animate { scrollLeft: carousel.width() * 2 + 100 }, 300
    else
      @.currentSlide -=1
      carousel.animate { scrollLeft: '-=' + ctrl.itemWidth }, 300

  ctrl.display =(val)->
    if @.currentSlide < 4
      @.condition = val < 4
    else if @.currentSlide > 7
      @.condition = val > 7
    else
      @.condition = val >= 4 && val <= 7
    @.condition

  ctrl.height = ->
    profile = document.getElementById('profile-right')
    if profile? && profile.clientHeight > 1
      @.currentHeight = profile.clientHeight
    return {"height": @.currentHeight + 'px', 'overflow': 'hidden'}

  $rootScope.backVendor = ->
    ctrl.seeMore(false)

  ctrl.seeMore =(state,type='')->
    @.showState.more = state
    $rootScope.backProfile = state
    $(window).scrollTop(0) if !!type
    switch type
      when 'about' then @.showState.about = true
      when 'location' then @.showState.location = true
      when 'packages' then @.showState.packages = true
      when 'services' then @.showState.services = true
      else
        @.showState.about = false
        @.showState.location = false
        @.showState.packages = false
        @.showState.services = false
    $timeout ->
      ctrl.mapOut() if state && type == 'location'

  ctrl.mapOut = ->
    map = Gmap.initMap('location-map',null)
    geocoder = new (google.maps.Geocoder)
    bounds = new (google.maps.LatLngBounds)
    count = @.locations.length
    @.locations.forEach (address) ->
      geocoder.geocode { 'address': address, componentRestrictions: country: 'AU'}, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          marker = new (google.maps.Marker)(
            position: results[0].geometry.location
            map: map)
          bounds.extend results[0].geometry.location
          if count == 1
            map.setCenter results[0].geometry.location
            map.setZoom 6
          else
            map.fitBounds bounds
        else
          console.error('Cannot find location in map', address)
          console.error status
        return

  return
angular.module('client').component 'vendorProfile',
  templateUrl: 'app/components/vendor_profile/index.html'
  controller: Ctrl
  bindings:
    vendor: "<"
    isLoggedin: "<"
    process: "<"
    isFave: "&"
    favorite: "&"
    unfavorite: "&"
    showLocation: "<"


angular.module('client').directive 'vendorCarousel',->
  templateUrl: 'app/components/vendor_profile/partials/carousel.html'

angular.module('client').directive 'vendorMobile',->
  templateUrl: 'app/components/vendor_profile/partials/mobile.html'

angular.module('client').directive 'profilePackages',->
  templateUrl: 'app/components/vendor_profile/partials/packages.html'

angular.module('client').directive 'profileRatings',->
  templateUrl: 'app/components/vendor_profile/partials/ratings.html'

angular.module('client').directive 'profileServices',->
  templateUrl: 'app/components/vendor_profile/partials/services.html'

angular.module('client').directive 'profileAbout',->
  templateUrl: 'app/components/vendor_profile/partials/about.html'

angular.module('client').directive 'profileLocations',->
  templateUrl: 'app/components/vendor_profile/partials/locations.html'

angular.module('client').directive 'profilePortfolio',->
  templateUrl: 'app/components/vendor_profile/partials/portfolio.html'
