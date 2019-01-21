module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/messages/:id", {id: '@id'},
    query:
      isArray: no
    snippets:
      url: "#{BASE_ENDPOINT}/messages/snippets"
      isArray: no

angular.module('client').factory('Message', module)
