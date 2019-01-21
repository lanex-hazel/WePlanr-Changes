angular.module('client').directive "pagination", ->
  restrict: "E"
  replace: true
  templateUrl: 'app/components/pagination/index.html'
  scope:
    count: "="
    page: "="
    onChange: "&"
    perPage: "<"

  link: ($scope, element, attrs) ->
    $scope.perpage = if !!$scope.perPage then parseInt($scope.perPage) else DEFAULT_PER_PAGE

    $scope.$watch '[page, count]', (values) ->
      if values[0] && values[1]
        page = values[0]
        count = values[1]
        $scope.totalPages = Math.ceil(count/$scope.perpage)
        if $scope.totalPages <= 10
          $scope.startPage = 1
          $scope.endPage = $scope.totalPages
        else
          if (page <= 6)
            $scope.startPage = 1
            $scope.endPage = 10
            $scope.endPage = $scope.totalPages if $scope.totalPages <= 10
          else if (page + 4) >= $scope.totalPages
            $scope.startPage = $scope.totalPages - 9
            $scope.endPage = $scope.totalPages
          else
            $scope.startPage = page - 5
            $scope.endPage = page + 4
        $scope.pages = _.range($scope.startPage, $scope.endPage + 1)
    $scope.page = 1 if !$scope.page
    $scope.queryPage =(params)->
      if params == 'prev'
        $scope.page--
      else if params == 'next'
        $scope.page++
      else
        $scope.page = params
      $scope.onChange({page: $scope.page})
