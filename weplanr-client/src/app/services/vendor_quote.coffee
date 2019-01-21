module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/my_vendors/:vendor_uid/quotes/:id", {vendor_uid: '@vendor_uid', id: '@id'},
    accept:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/quotes/:id/accept"
      params: {vendor_id: '@vendor_id', id: '@id'}
    fulfill:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/quotes/:id/fulfill"
      params: {vendor_id: '@vendor_id', id: '@id'}
    reject:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/quotes/:id/reject"
      params: {vendor_id: '@vendor_id', id: '@id'}
    query:
      isArray: no


angular.module('client').factory('VendorQuote', module)
