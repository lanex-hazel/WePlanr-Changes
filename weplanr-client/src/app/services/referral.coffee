module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/referrals", null,
    query:
      isArray: false

angular.module('client').factory('Referral', module)
