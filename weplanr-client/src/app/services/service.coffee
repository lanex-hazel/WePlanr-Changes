module = ($http, $resource, BASE_ENDPOINT, Cookie)->
  Service = $resource "#{BASE_ENDPOINT}/services", id: "@id",
    getList:
      method: 'GET'
      isArray: false
    categories:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/categories"
      isArray: false

  angular.extend Service,
    getCategories: ->
      $http.get("#{BASE_ENDPOINT}/categories").then (res)->
        Cookie.set('categories', res.data.data)


angular.module('client').factory('Service', module)
