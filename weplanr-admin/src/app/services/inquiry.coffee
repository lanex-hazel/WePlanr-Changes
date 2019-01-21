module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/admin/conversations/:id", {id: '@id'},
    query:
      url: "#{BASE_ENDPOINT}/admin/conversations?page[number]=:number"
      isArray: no

angular.module('client').factory('Inquiry', module)
