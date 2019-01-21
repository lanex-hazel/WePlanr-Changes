module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/admin/reward_transactions/:id", {id: '@id'},
    query:
      isArray: no
    update:
      method: 'PATCH'
      isArray: no

angular.module('client').factory('RewardTransaction', module)
