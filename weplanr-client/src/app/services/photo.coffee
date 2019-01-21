module = ($resource,BASE_ENDPOINT,Upload)->

  Photo = $resource "#{BASE_ENDPOINT}/my_vendors/:my_vendor_id/photos/:id", {my_vendor_id: "@my_vendor_id",id: "@id"},
    {
      delete:
        method: 'DELETE'
    }


angular.module('client').factory('Photo', module)
