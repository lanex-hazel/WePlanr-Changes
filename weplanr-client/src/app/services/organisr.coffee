module = ($resource, BASE_ENDPOINT)->
  $resource "#{BASE_ENDPOINT}/organisr", {id: "@id", type: "@type", todo_id: "@todo_id"},
    query:
      isArray: false
    addItem:
      method: 'POST'
      url: "#{BASE_ENDPOINT}/organisr/custom_todos"
    updateItem:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/organisr/:type/:id"
    removeItem:
      method: 'DELETE'
      url: "#{BASE_ENDPOINT}/organisr/:type/:id"
    restoreItem:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/organisr/budgets/:id/restore"
    categories:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/organisr/categories"
      isArray: false
    addVendor:
      method: 'POST'
      url: "#{BASE_ENDPOINT}/organisr/outside_vendors"
    updateVendor:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/organisr/outside_vendors/:id"
    updateBooking:
      method: 'PATCH'
      url: "#{BASE_ENDPOINT}/organisr/:type/:todo_id/bookings/:id/link"
      

angular.module('client').factory('Organisr', module)
