angular.module('client').directive 'vendorSettingsNav', ->
  templateUrl: 'app/components/vendor_settings_nav/index.html'
  scope:
    currentTab: "="
