module = ($resource,BASE_ENDPOINT)->

  Photo = $resource "#{BASE_ENDPOINT}/admin/photos/:id", {id: "@id"},
    {
      delete:
        method: 'DELETE'
    }
    



angular.module('client').factory('Photo', module)
