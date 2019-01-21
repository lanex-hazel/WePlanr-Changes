module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/services", id: "@id",
    getList:
      method: 'GET'
      isArray: false
    categories:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/categories"
      isArray: false

angular.module('client').factory('Service', module)
