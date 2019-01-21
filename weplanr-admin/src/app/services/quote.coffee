module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/admin/quotes/:id", {id: '@id'},
    query:
      url: "#{BASE_ENDPOINT}/admin/quotes?page[number]=:number"
      isArray: no
    queryBookings:
      url: "#{BASE_ENDPOINT}/admin/quotes/bookings?page[number]=:number"
      isArray: no

angular.module('client').factory('Quote', module)
