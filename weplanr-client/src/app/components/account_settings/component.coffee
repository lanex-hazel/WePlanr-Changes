Ctrl = ->
  ctrl = this

  ctrl.$onInit = ->
    @.user.newpassword = ''
    @.passview = 'password'
    @.disabled = true

  ctrl.toggle =(val)->
    @.disabled = val

  ctrl.onSubmit =(form,tab=false)->
    form.$submitted = true
    if form.$valid
      @.submit({vendor: @.vendor, user: @.user, redirect:tab})

  return

angular.module('client').component 'accountSettings',
  templateUrl: 'app/components/account_settings/index.html'
  controller: Ctrl
  bindings:
    vendor: "<"
    user: "<"
    loading: "<"
    submit: "&"
    temp: "<"
    deactivate: "&"
    errors: "="
