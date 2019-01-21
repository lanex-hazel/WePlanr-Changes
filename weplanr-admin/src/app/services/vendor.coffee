module = ($resource,BASE_ENDPOINT,$http)->

  Vendor = $resource "#{BASE_ENDPOINT}/admin/vendors/:vendor_uid", {vendor_uid: "@vendor_uid"},
    {
      get:
        method: 'GET'
      save:
        method: 'POST'
      update:
        method: 'PUT'
      delete:
        method: 'DELETE'
      invite:
        url: "#{BASE_ENDPOINT}/admin/vendors/:id/invite"
        params: id: '@id'
        method: 'POST'
      getList:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/admin/vendors?page[number]=:number"
        isArray: false
      setCoverPhoto:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/admin/vendors/:vendor_uid/cover_photo"
    }
    



angular.module('client').factory('Vendor', module)
