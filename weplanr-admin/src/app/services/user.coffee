module = ($resource,BASE_ENDPOINT,$http)->

  User = $resource "#{BASE_ENDPOINT}/admin/users/:id", {id: "@id"},
    {
      getList:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/admin/users?page[number]=:number"
        isArray: false
    }



angular.module('client').factory('User', module)
