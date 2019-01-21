angular.module('client').filter 'range', ->
  (input, total) ->
    total = parseInt(total)
    i = 0
    while i < total
      input.push i+1
      i++
    input


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

    $scope.$watch 'count', (newValue, oldValue) ->
      $scope.originalCount = Math.ceil($scope.count/$scope.perpage)
      $scope.pageCount = if $scope.originalCount > 8 then 8 else $scope.originalCount
    $scope.page = 1 if !$scope.page
    $scope.queryPage =(params)->
      if params == 'prev'
        $scope.page--
      else if params == 'next'
        $scope.page++
      else
        $scope.page = params
      $scope.onChange({page: $scope.page})
