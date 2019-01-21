Ctrl = ($scope,$state,$rootScope,$location,growl,Location,Vendor,Auth,User,MyVendor,Session,Upload,BASE_ENDPOINT,$timeout,Photo,Service,VendorReferral)->
  $scope.currentVendor = Session.get('currentVendor')
  $scope.user = Session.get('currentUser')
  $scope.portfolio_files = undefined
  $scope.referrals = {}
  $scope.referral_count = 0
  $scope.refer =
    email: ''
    error: false
    pattern: false

  $scope.uiState =
    loading: false
    uploading: false
    currentTab: 'profile'
    disabled: true
    errors: []
    pageTitle: 'Edit Settings'

  if !!$state.params.tab && $state.params.tab == 'referral' && !$rootScope.referralState.vendor
    $state.go('vendor.settings', {tab:'profile'})
  else if !!$state.params.tab
    $scope.uiState.currentTab = $state.params.tab

  abnFormat =(val)->
    val?.toString().replace(/\s+/g, '').split('').reverse().join('').replace(/(.{1,3})/g, '$1 ').trim().split('').reverse().join('')

  redirectpage =(tab)->
    if tab
      $state.go('vendor.settings', {tab: tab})
    else
      $state.go('vendor.dashboard')

  refreshDetails = ->
    MyVendor.getList().$promise
      .then (response)->
        Session.set('currentVendor', response.data[0].attributes)
        $scope.currentVendor = response.data[0].attributes
        $scope.currentVendor.business_number = abnFormat(response.data[0].attributes.business_number)
      .catch (err)->
        growl.error("Failed to fetch data.")

  $scope.uploadAvatarPhoto =(file)->
    $scope.uiState.uploading = true
    Upload.upload
      url: BASE_ENDPOINT + '/my_vendors/'+ $scope.currentVendor.slug
      method: 'PATCH'
      fields:
        'data[attributes][profile_photo]': file
      file: file
    .then(
      ((response)->
        angular.element("input[type='file']").val(null)
        Session.set('currentVendor', response.data.data.attributes)
        $scope.currentVendor = response.data.data.attributes
        $scope.temp = angular.copy($scope.currentVendor)),
      ((res)->
        console.error('Upload error', res)),
      (evt)->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        $scope.uploadPercent = progressPercentage
    )
    .finally ->
      $scope.uiState.uploading = false

  $scope.uploadPortfolio =(files,redirect)->
    if files.length > 0
      $scope.uiState.uploading = true
      data = new FormData()

      for item in files
        data.append 'vendor[photos][]', item
      $.ajax
        xhr: ->
          xhr = new (window.XMLHttpRequest)
          xhr.upload.addEventListener 'progress', ((evt) ->
            if evt.lengthComputable
              percentComplete = parseInt(100.0 * evt.loaded / evt.total)
              $('#bulkprogress').css('width', percentComplete + '%')
              $('#bulkprogress').text(percentComplete + '%')
            return
          ), false
          xhr
        url: BASE_ENDPOINT + '/my_vendors/'+ $scope.currentVendor.slug + '/photos'
        headers: 'Authorization': "Token token=\"#{Session.getAccessToken()}\""
        type: 'POST'
        dataType: 'json'
        processData: no # Don't process the files
        contentType: no # Set content type to false as jQuery will tell the server its a query string request
        data: data
        success: (data, textStatus, jqXHR) ->
          refreshDetails()
          $scope.uiState.uploading = false
          files.splice(0,files.length)
          redirectpage(redirect)
        error: (jqXHR, textStatus, errorThrown) ->
          $scope.uiState.uploading = false
          growl.error('Photo upload failed')
    else
      redirectpage(redirect)

  $scope.deletePhoto =(obj)->
    $scope.uiState.loading = true
    swal(DELETE_WARNING).then (isConfirm) ->
      if isConfirm
        Photo.delete(my_vendor_id:$scope.currentVendor.slug,id: obj.id).$promise
        .then (data)->
          $scope.uiState.loading = false
          refreshDetails()
          growl.success(MESSAGES.DELETE_SUCCESS)
        .catch (err)->
          $scope.uiState.loading = false
          growl.error('Photo cannot be deleted')
      else
        $scope.uiState.loading = false

  $scope.setCoverPhoto =(obj)->
    $scope.uiState.loading = true
    swal(SETCOVER_PHOTO_WARNING).then (isConfirm) ->
      if isConfirm
        Vendor.setCoverPhoto({id: $scope.currentVendor.slug, photo_id:obj.id}).$promise
          .then (response)->
            $scope.uiState.loading = false
            refreshDetails()
            growl.success('Successfully changed cover photo')
          .catch (err)->
            $scope.loading = false
            growl.error('Cannot change cover photo')
      else
        $scope.uiState.loading = false

  $scope.save =(vendor,redirect)->
    $scope.uiState.loading = true

    vendor_params =
      attributes: angular.copy(vendor)

    delete vendor_params.attributes.profile_photo
    delete vendor_params.attributes.photo_urls

    if vendor_params.attributes.social_channels is null || Object.keys(vendor_params.attributes.social_channels).length is 0
      vendor_params.attributes.social_channels = {empty: null}

    MyVendor.update({id: $scope.currentVendor.slug, data: vendor_params}).$promise
      .then (response)->
        growl.success('Successfully updated')
        Session.set('currentVendor', response.data.attributes)
        $scope.currentVendor = response.data.attributes
        Session.set('currentVendor', $scope.currentVendor)
        $scope.currentVendor.business_number = abnFormat(response.data.attributes.business_number)
        $scope.uiState.loading = false
        $scope.uiState.disabled = true
        redirectpage(redirect)
      .catch (err)->
        growl.error(MESSAGES.UPDATE_ERROR)
        $scope.uiState.loading = false
        $scope.uiState.disabled = true

  validateGST = (vendor)->
    if vendor.registered_for_gst is null and vendor.business_number
      swal(
        type: 'info'
        text: "Must indicate if you're registered for GST when providing ABN/ACN"
        confirmButtonColor: '#abcf85'
      )
      return false
    else
      return true

  $scope.saveAccount =(vendor,user,redirect)->
    return false unless validateGST(vendor)
    $scope.uiState.loading = true

    vendor_params =
      attributes:
        business_number: String(vendor.business_number).replace(/\s+/g, '')
        insurance: vendor.insurance
        registered_trading_name: vendor.registered_trading_name
        registered_for_gst: vendor.registered_for_gst
        registered_street_address: vendor.registered_street_address
        registered_suburb: vendor.registered_suburb
        registered_state: vendor.registered_state
        registered_country: vendor.registered_country
        registered_post_code: vendor.registered_post_code
        msg_notif_setting: vendor.msg_notif_setting

    user_params =
      attributes: {email: user.email}
    user_params.attributes.password = user.newpassword if user.newpassword != ''

    User.update(data: user_params).$promise
      .then (user)->
        MyVendor.update({id: $scope.currentVendor.slug, data: vendor_params}).$promise
          .then (vendor)->
            growl.success('Successfully updated')
            Session.set('currentUser', user.data.attributes)
            Session.set('currentVendor', vendor.data.attributes)
            $scope.currentVendor = vendor.data.attributes
            Session.set('currentVendor', $scope.currentVendor)
            $scope.currentVendor.business_number = abnFormat(vendor.data.attributes.business_number)
            $scope.uiState.loading = false
            $scope.uiState.disabled = true
            redirectpage(redirect)
          .catch (err)->
            errorMsg = if err.status == 422 then err.data.errors[0] else MESSAGES.UPDATE_ERROR
            growl.error(errorMsg)
            $scope.uiState.loading = false
            $scope.uiState.disabled = true
      .catch (err)->
        errorMsg = if err.status == 422 then err.data.errors[0] else MESSAGES.UPDATE_ERROR
        $scope.uiState.loading = false
        growl.error(errorMsg)

  $scope.deleteAccount = ->
    swal(DEACTIVATE_WARNING).then (isConfirm) ->
      if isConfirm
        growl.success(MESSAGES.DELETE_SUCCESS)

  $scope.getServices = ->
    Service.getList().$promise.then (res) -> $scope.services = res.data

  $scope.getLocations = ->
    Location.getList().$promise.then (res) -> $scope.locations = res.data.map (obj)-> obj['attributes']['name']

  $scope.referVendor = ->
    return $scope.refer.pattern = true unless /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/.test($scope.refer.email)
    if ($scope.refer.email && $scope.refer.email.trim() != '')
      VendorReferral.save(vendor_uid: $scope.currentVendor.slug, data: attributes: referred_email: $scope.refer.email).$promise
        .then (response)->
          $scope.refer =
            email: ''
            error: false
            pattern: false
          swal('', 'Thank you for referring a vendor!', 'success')
        .catch (err)->
          growl.error(err.data.errors[0]) if err.status == 422
    else
      $scope.refer.error = true

  $scope.fetchReferrals = ->
    VendorReferral.query(vendor_uid: $scope.currentVendor.slug).$promise.then (res)->
      $scope.referrals.vendor = res.vendor_referral
      $scope.referrals.list = res.data
      $scope.referral_count = res.meta.record_count

  $scope.fetchReferrals()
  $scope.getServices()
  $scope.getLocations()
  $scope.currentVendor.business_number = abnFormat($scope.currentVendor.business_number)

angular.module('client').controller('VendorSettingsCtrl', Ctrl)
