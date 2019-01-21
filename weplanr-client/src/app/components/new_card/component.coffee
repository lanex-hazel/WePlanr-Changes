angular.module('client').directive 'newCard', (BankCard, growl)->
  restrict: 'E'
  replace: yes
  templateUrl: 'app/components/new_card/index.html'
  scope:
    save: '&onSave'
    cancel: '&onCancel'
    title: '='
  link: ($scope, $element, $attrs)->
    currentYear = new Date().getFullYear()
    $scope.yearOptions = [currentYear]
    $scope.yearOptions.push(currentYear + num) for num in [1..5]

    resetCard = ->
      $scope.newCard =
        name: null
        number: null
        exp_month: null # mm
        exp_year: null # yyyy
        cvc: null
    resetCard()

    $scope.submit = ->
      $scope.loading = on
      BankCard.save(data: attributes: $scope.newCard).$promise
        .then (res)->
          $scope.save() if $scope.save
          resetCard()
          growl.success('You have successfully save your new card account.')
        .finally ->
          $scope.loading = no
