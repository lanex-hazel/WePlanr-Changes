module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/my_vendors/:vendor_uid/messages/:id", {vendor_uid: '@vendor_uid', id: '@id'},
    query:
      isArray: no
    snippets:
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_uid/messages/snippets"
      params:
        vendor_uid: '@vendor_uid'
      isArray: no

angular.module('client').factory('VendorMessage', module)
