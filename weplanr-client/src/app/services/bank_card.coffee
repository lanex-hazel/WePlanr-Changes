module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/profile/bank_cards/:id", {id: '@id'},
    query:
      isArray: no

angular.module('client').factory('BankCard', module)
