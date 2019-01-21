angular.module('client').directive 'pwCheck', ->
  require: 'ngModel'
  link: (scope, elem, attrs, ctrl) ->
    firstPassword = '#' + attrs.pwCheck
    elem.add(firstPassword).on 'keyup', ->
      scope.$apply ->
        # console.info(elem.val() === $(firstPassword).val());
        ctrl.$setValidity 'pwmatch', elem.val() == $(firstPassword).val()
        return
      return
    return
