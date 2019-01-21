module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/invoices/:id", {id: '@id'},
    query:
      isArray: no

angular.module('client').factory('Invoice', module)
