module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/features/:id", {id: '@id'},
    query:
      isArray: no

angular.module('client').factory('Feature', module)
