module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/locations", id: "@id",
    getList:
      method: 'GET'
      isArray: false

angular.module('client').factory('Location', module)
