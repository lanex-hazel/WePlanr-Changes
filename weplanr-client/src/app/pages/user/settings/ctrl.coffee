Ctrl = ($scope,$state,$rootScope,growl,Auth,Session,User,Upload,BankCard,Referral,Reward,BASE_ENDPOINT,$timeout)->
  $scope.loading = no
  $scope.uploading = no
  $scope.uploadPercent = 0
  $scope.currentTab = 'profile'
  $scope.brideOrGroom = ['groom', 'bride']

  $scope.dateFormat = 'D.MM.YY'
  $scope.minDate = moment().add('day', 1)
  $scope.maxDate = moment().add('years', 5)
  $scope.form_valid = true

  $scope.myImage = null
  $scope.croppedImage = ''
  $scope.referred_list = []
  $scope.refer =
    email: null
    error: false

  $timeout ->
    if !!$state.params.tab && $state.params.tab == 'referral' && !$rootScope.referralState.customer
      $state.go('user.settings', {tab:'profile'})
    if !!$state.params.tab && $state.params.tab == 'rewards' && !$rootScope.rewardState.customer
      $state.go('user.settings', {tab:'profile'})
    else if !!$state.params.tab
      $scope.currentTab = $state.params.tab

  $scope.status = {pending: 'Invited', accepted: 'Registered', booked: 'Booked'}
  budget = ''

  setUser = (data)->
    Auth.setUser(attributes: data)
    Session.set('currentUser', data)
    $scope.profile_photo = data.profile_photo
    $scope.user = angular.copy(data)
    $scope.user.wedding_details.date = moment($scope.user.wedding_details.date).format($scope.dateFormat) if $scope.user.wedding_details.date
    budget = $scope.user.wedding_details.budget

  setUser(Session.get('currentUser'))

  $scope.setImage=(files,evt)->
    reader = new FileReader
    reader.readAsDataURL(files[0])
    reader.onload = ->
      $scope.$apply ($scope) ->
        $scope.myImage = reader.result

  $scope.saveProfile =(redirect=false)->
    if $scope.user.user_settings.recalculate_planned && budget != $scope.user.wedding_details.budget
      swal(RECALCULATE_BUDGET_PLANNED).then (isConfirm) ->
        if isConfirm
          updateFunc(redirect)
    else
      updateFunc(redirect)

  updateFunc =(redirect)->
    params = angular.copy($scope.user)
    weddingDate = moment(params.wedding_details.date, $scope.dateFormat).format('YYYY-MM-DD')
    $scope.form_valid = weddingDate >= moment().format('YYYY-MM-DD')
    if $scope.form_valid
      $scope.loading = on
      delete params.profile_photo
      delete params.auth_token
      delete params.is_vendor
      delete params.outstanding_todo
      delete params.pending_todos
      delete params.uid
      delete params.user_settings

      params.wedding_details.date = weddingDate
      params.wedding_details.budget = String(params.wedding_details.budget).replace(/\s+/g, '')
      params.wedding_details.location =
        if params.wedding_details.location == undefined then '' else params.wedding_details.location

      User.update(data: attributes: params).$promise
        .then (res)->
          setUser(res.data.attributes)
          message = MESSAGES.UPDATE_SUCCESS
          message += '. Password updated.' if !!params.password
          growl.success(message)
          if redirect
            $state.go('user.settings', {tab: redirect})
          else
            $state.go('user.dashboard')
        .finally ->
          $scope.loading = no

  $scope.uploadPhoto = (file)->
    return if file is null
    $scope.myImage = null
    $scope.uploading = on
    Upload.upload
      url: BASE_ENDPOINT + '/profile'
      method: 'PATCH'
      fields: 'data[attributes][profile_photo]': Upload.dataUrltoBlob(file)
      file: Upload.dataUrltoBlob(file)
    .then(
      ((res)->
        setUser(res.data.data.attributes)
        angular.element("input[type='file']").val(null)),
      ((res)->
        console.error('Upload error', res)),
      (evt)->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        $scope.uploadPercent = progressPercentage
    )
    .finally ->
      $scope.uploading = no

  $scope.cancelUpload = ->
    $scope.myImage = null


  #==================
  #  CARD & BANKS
  #==================
  $scope.showCardForm = ->
    $scope.showNewCard= yes

  $scope.fetchBankCards = ->
    BankCard.query().$promise.then (res)->
      $scope.cardAccounts = res.data

  $scope.fetchBankCards()

  $scope.onSaveCard = ->
    $scope.fetchBankCards()
    $scope.showNewCard = no


  #==================
  #  DELETE ACCOUNT
  #==================
  deleteWarning = $.extend(true, {}, DELETE_WARNING, confirmButtonText: 'DELETE MY ACCOUNT')
  $scope.deleteAccount = ->
    swal(deleteWarning).then (confirmed) ->
      return unless confirmed
      User.destroy().$promise.then (response)->
        Auth.removeUser()
        Session.removeSession()
        growl.success('You have successfully deleted your wedding.')
        $state.go('main.intro')

  # Setuo geotagging for wedding location
  $timeout ->
    autocomplete = new google.maps.places.Autocomplete(document.getElementById('wedding-location'))
    autocomplete.addListener 'place_changed', ->
      $scope.user.wedding_details.location = autocomplete.getPlace().name

  #==================
  #  REFERRAL
  #==================
  $scope.referVendor = ->
    return $scope.refer.pattern = true unless /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/.test($scope.refer.email)
    if ($scope.refer.email && $scope.refer.email.trim() != '')
      Referral.save(data: attributes: referred_email: $scope.refer.email).$promise
        .then (response)->
          $scope.refer =
            email: ''
            error: false
            pattern: false
          swal('Thank you for referring a vendor!', '', 'success')
        .catch (err)->
          growl.error(err.data.errors[0]) if err.status == 422
    else
      $scope.refer.error = true

  fetchReferral = ->
    Referral.query().$promise.then (res)->
      $scope.referred_list = res.data
      $scope.gift_cards = res.data.filter((obj) -> obj['attributes']['gift_card_sent'] == true).length

  fetchReward = ->
    Reward.query().$promise.then (res)->
      $scope.rewards = res.data.attributes

  fetchReferral()
  fetchReward()

angular.module('client').controller('SettingsCtrl', Ctrl)
