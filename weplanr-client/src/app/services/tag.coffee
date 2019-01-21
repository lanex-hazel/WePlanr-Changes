module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/tags", id: "@id",
    searchTag:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/tags?q"
      isArray: false

angular.module('client').factory('Tag', module)
