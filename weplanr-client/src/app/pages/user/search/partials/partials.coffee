angular.module('client').directive 'uvendorSearch',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/search/partials/search_form.html'
  link: (scope, elm, attrs) ->

    scope.searchToggle =(val)->
      scope.toggle = !val

    scope.reset = ->
      scope.query.services = ''
      scope.query.date = ''
      scope.query.locations = ''
      scope.keywords = {}
      scope.search(scope.query)

    scope.selectService = (item,model) ->
      scope.keywords.services = item.attributes.name
      scope.search(scope.query)