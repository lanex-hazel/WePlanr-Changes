module = ($resource,BASE_ENDPOINT)->

  Wedding = $resource "#{BASE_ENDPOINT}/wedding", null,
    {

      update:
        method: 'PATCH'
    }

angular.module('client').factory('Wedding', module)
