module = ($resource,BASE_ENDPOINT)->

  $resource "#{BASE_ENDPOINT}/my_vendors/:id", {id: "@id"},
    getStats:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/my_vendors/:id/statistics"
      isArray: no
    getList:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/my_vendors"
      isArray: false
    update:
      method: 'PATCH'

angular.module('client').factory('MyVendor', module)
