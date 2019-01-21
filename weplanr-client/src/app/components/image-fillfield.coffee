
module = angular.module("imageFillfield", [])

module.directive 'imageFillfield', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.imgLiquid()

    return