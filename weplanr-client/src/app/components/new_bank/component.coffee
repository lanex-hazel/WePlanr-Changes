angular.module('client').directive 'newBank', (BankAccount, growl)->
  restrict: 'E'
  replace: yes
  templateUrl: 'app/components/new_bank/index.html'
  scope:
    save: '&onSave'
    cancel: '&onCancel'
  link: ($scope, $element, $attrs)->
    $scope.accountTypes = ['savings', 'checking']
    $scope.holderTypes = ['individual', 'company']

    resetBank = ->
      $scope.newBank =
        bank_name: null
        account_holder_name: null
        account_holder_number: null
        account_holder_type: null # personal or business
        routing_number: null # routing / SWIFT / IBAN
        country: 'AUS' # ISO code (3 char)
        currency: 'aud'
    resetBank()

    $scope.submit = ->
      $scope.loading = on
      BankAccount.save(data: attributes: $scope.newBank).$promise
        .then (res)->
          $scope.save() if $scope.save
          resetBank()
          growl.success('You have successfully save your new bank account.')
        .finally ->
          $scope.loading = no
