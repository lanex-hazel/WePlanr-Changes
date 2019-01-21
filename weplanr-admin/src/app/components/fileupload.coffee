module = angular.module("fileModel", [])

module.directive 'fileModel', [
  '$parse'
  ($parse) ->
    {
      # restrict: 'A'
      # link: (scope, element, attrs) ->
      #   model = $parse(attrs.fileModel)
      #   modelSetter = model.assign
      #   element.bind 'change', ->
      #     scope.$apply ->
      #       modelSetter scope, element[0].files[0]
      #       return
      #     return
      #   return

      restrict: 'A'
      link: (scope, element, attrs) ->
        model = $parse(attrs.fileModel)
        isMultiple = attrs.multiple
        modelSetter = model.assign
        element.bind 'change', ->
          values = []
          angular.forEach element[0].files, (item) ->
            value =
              name: item.name
              size: item.size
              url: URL.createObjectURL(item)
              _file: item
            values.push value
            return
          scope.$apply ->
            if isMultiple
              modelSetter scope, values
            else
              modelSetter scope, values[0]
            return
          return
        return
    }
]