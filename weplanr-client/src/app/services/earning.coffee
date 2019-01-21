module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/my_vendors/earnings", {},
    query:
      isArray: no

angular.module('client').factory('Earning', module)
