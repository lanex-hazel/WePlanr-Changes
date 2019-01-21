Ctrl = ->
  ctrl = this

  return
angular.module('client').directive 'menuBar', ->
  templateUrl: 'app/components/menu/index.html'
  controller: Ctrl
  scope:
    view: "="
    toggle: "&"
    isVendor: "<"