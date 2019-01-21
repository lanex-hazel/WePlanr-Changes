Ctrl = ->
  ctrl = this

  ctrl.$onInit = ->
    @.creds =
      username: ''
      password: ''

  ctrl.submit =(form)->
    form.$submitted = true
    if form.$valid
      @.login({creds: @.creds})

  return

angular.module('client').component 'loginForm',
  templateUrl: 'app/components/login_form/index.html'
  controller: Ctrl
  bindings:
    login: "&"
    loading: "="
