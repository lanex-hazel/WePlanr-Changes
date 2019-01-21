module = ($resource,BASE_ENDPOINT)->

  Todo = $resource "#{BASE_ENDPOINT}/todos", {id: "@id"},
    query:
      isArray: false
    dashboard:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/todos/dashboard"
    saveNote:
      method: 'POST'
      url: "#{BASE_ENDPOINT}/todos/:id/notes"


angular.module('client').factory('Todo', module)
