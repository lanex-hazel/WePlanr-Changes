Ctrl = ($scope,Gmap,growl,filterFilter,Session,$timeout)->
  ctrl = this

  ctrl.$onInit = ->
    @.newSocial = []
    @.newPackage = []
    @.newLocation = ''
    @.selectTag = []
    @.temp_services = []
    @.temp_locations = []
    @.temp_socials = {}
    @.selectedSocial = []
    @.state =
      addLocation: false
      addPackage: false
      disableAdd: false
    @.newAvatar = ''
    @.cropAvatar = ''
    @.socialOpt = [
      'facebook',
      'instagram',
      'pinterest',
      'twitter',
      'youtube',
      'vimeo'
    ]

  $timeout ->
    ctrl.mapOut()

    $scope.$watch '$ctrl.vendor', (value) ->
      if value?
        ctrl.profile_photo = ctrl.vendor.profile_photo
        ctrl.filterSocials(ctrl.vendor.social_channels)
      if ctrl.vendor?.tags?
        ctrl.vendor.tag_list = ctrl.vendor.tags.map (tag)-> text: tag
      if ctrl.vendor?.other_locations?
        ctrl.vendor.other_location_list = ctrl.vendor.other_locations.map (loc)-> text: loc

    $scope.$watch '$ctrl.vendor.address_summary', (newval, oldval)->
      ctrl.mapOut() if newval

    $scope.$watch '$ctrl.serviceOpt', (value) ->
      if value?
        ctrl.primary_services = ctrl.serviceOpt.filter (obj)->
          obj.attributes.category?.id == ctrl.vendor.primary_service_id
        ctrl.secondary_services = ctrl.serviceOpt.filter (obj)->
          obj.attributes.category?.id != ctrl.vendor.primary_service_id

  ctrl.addSocial =(index, value)->
    @.newSocial[index].social = value

  ctrl.serviceMargin = ->
    elem = $('#primary-service')
    {'margin-left': elem.width() + 4}

  ctrl.filterSocials =(obj)->
    if obj?
      ctrl.socialOpt.filter (el) ->
        if Object.keys(obj).indexOf(el) > -1
          ctrl.socialOpt = filterFilter(ctrl.socialOpt, '!' + el)

  ctrl.mapOut = ->
    map = Gmap.initMap('map',null)
    geocoder = new (google.maps.Geocoder)
    bounds = new (google.maps.LatLngBounds)
    address = @.vendor.address_summary
    geocoder.geocode { 'address': address, componentRestrictions: country: 'AU'}, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        marker = new (google.maps.Marker)(
          position: results[0].geometry.location
          map: map)
        bounds.extend results[0].geometry.location
      else
        console.error('Cannot find location in map')

  ctrl.addData =(obj,isSocial=false)->
    index = obj.length+1
    obj.push {'id':index}
    @.state.disableAdd = true if isSocial and index >= @.socialOpt.length

  ctrl.newVal =(type)->
    switch type
      when 'loc' then @.state.addLocation = !@.state.addLocation
      when 'package' then @.state.addPackage = !@.state.addPackage

  ctrl.removeData =(index,obj,isSocial=false)->
    if Array.isArray(obj)
      obj.splice(index,1)
      if isSocial
        @.selectedSocial.splice(index,1)
        @.state.disableAdd = false
    else
      delete obj[index]
      @.filterSocials(obj)
      @.state.disableAdd = false

  ctrl.addLoc = ->
    @.vendor.locations = [] if !@.vendor.locations
    @.vendor.locations.push @.newLocation
    @.locationOpt.splice(@.locationOpt.indexOf(@.newLocation), 1)
    @.newLocation = ''
    @.state.addLocation = false

  ctrl.removeLocation =(index)->
    @.vendor.locations.splice(index,1)
    ctrl.locationOpt = ctrl.temp_locations.filter (el) ->
      ctrl.vendor.locations.indexOf(el) < 0 if ctrl.vendor.locations

  ctrl.toggle =(val)->
    @.disabled = val

  ctrl.cancelUpload = ->
    @.cropAvatar = null

  ctrl.onUpload =(file)->
    @.cropAvatar = null
    @.upload({file:file})

  ctrl.convert_obj =(vendor)->
    @.newSocial.forEach (item) ->
      vendor.social_channels = {} if !vendor.social_channels
      vendor.social_channels[item.social] = item.link if !!item.social && !!item.link

    @.newPackage.forEach (item) ->
      vendor.pricing_and_packages.push {name: item.name, price: item.price} unless !item.name

    @.newSocial = []
    @.newPackage = []
    @.selectedSocial = []

  ctrl.onSubmit =(form,tab=false)->
    @.vendor.services = @.vendor.primary_services.concat(@.vendor.secondary_services)
    form.$submitted = true
    @.convert_obj(@.vendor)
    @vendor.tags = []
    @vendor.tags.push(tag.text) for tag in @vendor.tag_list
    @vendor.other_locations = @vendor.other_location_list.map (loc)-> loc.text
    if form.$valid
      @.submit({vendor: @.vendor, redirect: tab})

  ctrl.setImage=(files,evt)->
    if files[0].$error
      swal('Upload Failed','Image has an invalid file type. Try again.','warning')
    else
      reader = new FileReader
      reader.readAsDataURL(files[0])
      reader.onload = ->
        ctrl.cropAvatar = reader.result
        $scope.$apply()

  return
angular.module('client').component 'profileSettings',
  templateUrl: 'app/components/profile_settings/index.html'
  controller: Ctrl
  bindings:
    vendor: "="
    loading: "<"
    uploading: "<"
    uploadPercent: "<"
    temp: "<"
    disabled: "="
    submit: "&"
    upload: "&"
    serviceOpt: "="
    locationOpt: "="
