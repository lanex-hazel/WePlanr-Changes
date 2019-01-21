module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/reward", null,
    query:
      isArray: false

angular.module('client').factory('Reward', module)
