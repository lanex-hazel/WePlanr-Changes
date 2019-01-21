module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/transactions/:id", {id: '@id'},
    query:
      isArray: no

angular.module('client').factory('Transaction', module)
