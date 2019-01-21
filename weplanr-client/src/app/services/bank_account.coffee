module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/profile/bank_accounts/:id", {id: '@id'},
    query:
      isArray: no

angular.module('client').factory('BankAccount', module)
