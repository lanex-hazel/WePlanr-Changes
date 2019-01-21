module = ($resource,BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/my_vendors/:vendor_uid/referrals", {vendor_uid: '@vendor_uid', id: '@id'},
    query:
      isArray: no

angular.module('client').factory('VendorReferral', module)
