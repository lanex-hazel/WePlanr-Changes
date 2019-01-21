Ctrl = ($scope,$state,$rootScope,growl,BASE_ENDPOINT,Vendor,Photo,Session,Service,Setting,filterFilter,Location,Upload)->

  $scope.temp = ''
  $scope.uploadOngoing = false
  $scope.services = []
  $scope.selectTag = []
  $scope.temp_services = []
  $scope.selectedSocial = []
  $scope.newVar =
    packages: []
    links: []
  $scope.socialOpt = Setting.socialOpt()
  $scope.uiState =
    loading: false
    currentTab: "account"

  $scope.avatar = ''
  $scope.img_gallery = []
  $scope.errors = ''
  update_link = BASE_ENDPOINT + "/admin/vendors/" + $state.params.id
  $scope.myImage = null
  $scope.croppedImage = ''

  $scope.details = ->
    $scope.uiState.loading = true
    Vendor.get({vendor_uid: $state.params.id}).$promise
      .then (resp) ->
        $scope.avatar = $rootScope.sanitize_url(resp.data.attributes.profile_photo) if resp.data.attributes.profile_photo
        $scope.portfolio_photos = resp.data.attributes.photo_urls.map((link) -> {
          'id': link.id,
          'image': $rootScope.sanitize_url(link.url),
          'cover_photo': link.cover_photo})
        delete resp.data.attributes.photo_urls
        delete resp.data.attributes.status
        delete resp.data.attributes.profile_photo
        $scope.vendor = resp.data.attributes
        if $scope.vendor.other_locations?
          $scope.vendor.other_location_list = $scope.vendor.other_locations.map (loc)-> text: loc
        if $scope.vendor.tags?
          $scope.vendor.tag_list = $scope.vendor.tags.map (tag)-> text: tag
        $scope.temp = angular.copy $scope.vendor
        $scope.selectTag = $scope.vendor.services if $scope.vendor.services?
        $scope.filterSocials($scope.vendor.social_channels)
      .finally ->
        $scope.uiState.loading = false
 
  $scope.addData =(obj)->
    id = obj.length+1
    obj.push {'id':id}

  $scope.removeData =(index,obj,isSocial)->
    if Array.isArray(obj)
      obj.splice(index,1)
      $scope.selectedSocial.splice(index,1) if isSocial
    else
      delete obj[index]
      $scope.filterSocials(obj)
  $scope.adds =(obj,val)->
    obj.push val
    val = ''

  $scope.onCancel = ->
    $scope.vendor = $scope.temp
    $scope.vendor.services = $scope.temp_services if $scope.temp_services.length > 0
    $scope.selectTag = []
    $scope.temp_services = []
    for s in $scope.vendor.services
      $scope.selectTag.push s
      $scope.temp_services.push s
    $scope.selectedSocial = []
    $scope.newVar =
      packages: []
      links: []
  
  $scope.onSave =(form)->
    $scope.uiState.loading = true
    $scope.newVar.links.forEach (item) ->
      $scope.vendor.social_channels = {} if !$scope.vendor.social_channels
      $scope.vendor.social_channels[item.social] = item.link if !!item.social

    $scope.newVar.packages.forEach (item) ->
      $scope.vendor.pricing_and_packages = [] unless !!$scope.vendor.pricing_and_packages
      $scope.vendor.pricing_and_packages.push {name: item.name, price: item.price} unless !item.name
    
    $scope.selectedSocial = []
    $scope.newVar =
      packages: []
      links: []

    params =
      id: $state.params.id
      attributes: $scope.vendor
    if $scope.vendor.social_channels and Object.keys($scope.vendor.social_channels).length is 0
      params.attributes.social_channels = {empty: null}
    form.$submitted = true
    params.attributes.other_locations = $scope.vendor.other_location_list.map (loc)-> loc.text
    params.attributes.tags = $scope.vendor.tag_list.map (tag)-> tag.text
    params.attributes.services = $scope.vendor.primary_services.concat($scope.vendor.secondary_services)
    if form.$valid
      Vendor.update({vendor_uid: $state.params.id, data: params}).$promise
        .then (data)->
          $scope.details()
          form.$pristine = false
          $scope.uiState.loading = false
          growl.success('Successfully Updated.')
        .finally ->
          $scope.uiState.loading = false
    else
      console.error 'invalid form'
      $scope.uiState.loading = false
      angular.element('input.ng-invalid:first').focus()

  $scope.confirmDelete =(obj)->
    $scope.uiState.loading = true
    swal(DELETE_PHOTO_WARNING).then (isConfirm) ->
      if isConfirm
        Photo.delete(id: obj.id).$promise
        .then (data)->
          $scope.details()
          $scope.uiState.loading = false
          growl.success(MESSAGES.DELETE_SUCCESS)
        .catch (err)->
          $scope.uiState.loading = false
          growl.error('Photo cannot be deleted.')
      else
        $scope.uiState.loading = false

  $scope.uploadAvatar = (file)->
    if file is null
      $scope.uploadOngoing = false
    else
      $scope.uploadOngoing = true
      Upload.upload
        url: update_link
        method: 'PATCH'
        fields: 'data[attributes][profile_photo]': file
        file: file
      .then (res)->
        $scope.avatar = $rootScope.sanitize_url(res.data.data.attributes.profile_photo)
        swal('Profile photo uploaded','','success')
      .finally ->
        $scope.uploadOngoing = false
      $scope.myImage = null

  $scope.setImage=(files,evt)->
    reader = new FileReader
    reader.readAsDataURL(files[0])
    reader.onload = ->
      $scope.$apply ($scope) ->
        $scope.myImage = reader.result

  $scope.cancelUpload = ->
    $scope.myImage = null

  $scope.upload_portfolio =(files)->
    $scope.uploadOngoing = true
    $scope.errors = ''
    upload_request = false
    exceedPhotos = false
    data = new FormData()
    maxPhotos = 12 - $scope.portfolio_photos.length

    if files and files.length <= maxPhotos
      while files.length > 0
        if files[0].$error
          $scope.errors += identifyError(files[0])
        else
          upload_request = true
          data.append 'vendor[photos][]', files[0]
        files.splice(0,1)
    else
      exceedPhotos = true
      swal('Reached photo limit!','You are only allowed to upload up to 12 photos.','error')
    if upload_request
      $.ajax
        xhr: ->
          xhr = new (window.XMLHttpRequest)
          xhr.upload.addEventListener 'progress', ((evt) ->
            if evt.lengthComputable
              percentComplete = parseInt(100.0 * evt.loaded / evt.total)
              $('#progress').css('width', percentComplete + '%')
              $('#progress').text(percentComplete + '%')
          ), false
          xhr
        url: update_link + "/photos"
        headers: 'Authorization': "Token token=\"#{Session.getToken()}\""
        type: 'POST'
        dataType: 'json'
        processData: no # Don't process the files
        contentType: no # Set content type to false as jQuery will tell the server its a query string request
        data: data
        success: (data, textStatus, jqXHR) ->
          $scope.uploadOngoing = false
          $scope.img_gallery = []
          angular.element("input[type='file']").val(null)
          $scope.details()
          swal('Photo/s upload success','','success')
          swal('Photo/s upload failed',$scope.errors,'warning') if $scope.errors
        error: (jqXHR, textStatus, errorThrown) ->
          $scope.uploadOngoing = false
          growl.error('Failed to upload image.')
    else
      $scope.img_gallery = []
      angular.element("input[type='file']").val(null)
      $scope.uploadOngoing = false
      swal('Photo/s upload failed',$scope.errors,'warning') if !exceedPhotos

  identifyError =(file)->
    switch file.$error
      when 'pattern'
        return file.name + " is an invalid image file.\n"
      when 'minWidth' or 'minHeight'
        return file.name + " must be atleast 800x600(landscape) or 600x800(portrait).\n"
      when 'maxSize'
        return file.name + " is larger than the maximum allowed limit of 5MB.\n"

  $scope.updatePrimaryService = ->
    internalId = $scope.vendor.internal_id
    if matched = internalId?.match(/^(\d+)\.\d+$/)
      matchedService = $scope.categories.find((category)-> category.id.toString() is matched[1])
      $scope.primaryService = matchedService?.name
      $scope.vendor.primary_service_id = matchedService?.id if matchedService?

  $scope.getServices = ->
    Service.getList().$promise.then (res) ->
      $scope.services = res.data
      $scope.$watch 'vendor.primary_service_id', (newVal, oldVal) ->
        if newVal
          $scope.primary_services = res.data.filter (obj) ->
            obj.attributes.category?.id == $scope.vendor.primary_service_id
          $scope.secondary_services = res.data.filter (obj) ->
            obj.attributes.category?.id != $scope.vendor.primary_service_id

  $scope.getCategories = ->
    Service.categories().$promise.then (res) ->
      $scope.categories = res.data
      $scope.$watch 'vendor.primary_service_id', (newVal, oldVal) ->
        if newVal
          $scope.primaryService = res.data.find((category)-> category.id is newVal)?.name

  $scope.getLocations = ->
    Location.getList().$promise.then (res) -> $scope.locationOpt = res.data

  $scope.filterSocials =(obj)->
    if obj?
      $scope.socialOpt.filter (el) ->
        if Object.keys(obj).indexOf(el) > -1
          $scope.socialOpt = filterFilter($scope.socialOpt, '!' + el)

  $scope.setCoverPhoto =(obj)->
    swal(SETCOVER_PHOTO_WARNING).then (isConfirm) ->
      if isConfirm
        $scope.uiState.loading = true
        Vendor.setCoverPhoto({vendor_uid: $state.params.id, photo_id:obj.id}).$promise
          .then (response)->
            $scope.details()
            $scope.uiState.loading = false
            growl.success('Successfully updated cover photo')
          .catch (err)->
            $scope.uiState.loading = false
            growl.error('Unable to change cover photo')
      else
        $scope.uiState.loading = false

  $scope.getServices()
  $scope.getCategories()
  $scope.getLocations()
  $scope.details()

angular.module('client').controller('VendorDetailCtrl', Ctrl)
