module = ($resource,BASE_ENDPOINT)->

  $resource "#{BASE_ENDPOINT}/admin/dashboard", {},
    query:
      isArray: no
    generateSitemap:
      url: "#{BASE_ENDPOINT}/admin/generate_sitemap"
      isArray: no

angular.module('client').factory('Dashboard', module)
