module = ($resource,BASE_ENDPOINT,$http)->

  $resource "#{BASE_ENDPOINT}/admin/todos/:id", {id: "@id"},
    getList: isArray: no
    update: method: 'PATCH'



angular.module('client').factory('Todo', module)
