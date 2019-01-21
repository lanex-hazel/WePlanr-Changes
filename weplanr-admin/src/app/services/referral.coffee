module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/admin/referrals/:id", {id: '@id'},
    query:
      isArray: no
    update:
      method: 'PATCH'
      isArray: no

angular.module('client').factory('Referral', module)
