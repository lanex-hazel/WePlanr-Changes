module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/admin/features/:id", {id: '@id'},
    query:
      isArray: no
    update:
      method: 'PATCH'
      isArray: no

angular.module('client').factory('Feature', module)
