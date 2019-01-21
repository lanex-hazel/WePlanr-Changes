Ctrl = ($scope,$state,$filter,$window,$timeout,BASE_ENDPOINT,Referral,RewardTransaction,Session)->
  $scope.activeTab = 1
  $scope.statusFilter = $state.params.status or 'all'
  $scope.loading = yes

  referralDaterange = $("#referral-date-rangepicker")
  rewardsDaterange = $('#reward-date-rangepicker')
  rangepickerParams =
    autoUpdateInput: no
    drops: 'up'
    locale:
      format: 'DD MMM YYYY'
      cancelLabel: 'Clear'
    ranges:
      'Last 24 hours': [moment().subtract(24, 'hours'), moment()]
      'Last 7 days': [moment().subtract(7, 'days').startOf('day'), moment()]
      'Last 14 days': [moment().subtract(14, 'days').startOf('day'), moment()]
      'Last 30 days': [moment().subtract(30, 'days').startOf('day'), moment()]
      'Last 60 days': [moment().subtract(60, 'days').startOf('day'), moment()]
      'Last 90 days': [moment().subtract(90, 'days').startOf('day'), moment()]
      'More than 90 days': [moment('01Aug2017', 'DDMMMYYYY'), moment().subtract(91, 'days').endOf('day')]
  $timeout ->
    referralDaterange
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        referralDaterange.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
      )
    rewardsDaterange
      .daterangepicker(rangepickerParams)
      .on('cancel.daterangepicker', -> $(this).val(''))
      .on('apply.daterangepicker', (ev, picker)->
        rewardsDaterange.val(picker.startDate.format('DD MMM YYYY') + ' - ' + picker.endDate.format('DD MMM YYYY'))
      )

    $scope.fetchRewards()
    $scope.fetchReferrals()

  getReferralsFilters = ->
    filters = status: $scope.statusFilter
    if referralDaterange.val() isnt ''
      filters.created_since = referralDaterange.data('daterangepicker').startDate.toISOString()
      filters.created_until = referralDaterange.data('daterangepicker').endDate.toISOString()
    angular.extend(referred_by: 'customer', filters)

  getRewardsFilters = ->
    filters = {}
    if rewardsDaterange.val() isnt ''
      filters.created_since = rewardsDaterange.data('daterangepicker').startDate.toISOString()
      filters.created_until = rewardsDaterange.data('daterangepicker').endDate.toISOString()
    filters

  $scope.fetchRewards = ->
    $scope.loading = yes
    RewardTransaction.query(getRewardsFilters()).$promise.then (res)->
      $scope.rewards = res.data
      $scope.loading = no

  $scope.fetchReferrals = ->
    $scope.loading = yes
    Referral.query(getReferralsFilters()).$promise.then (res)->
      $scope.referrals = res.data
      $scope.loading = no


  $scope.toggleReward = (obj, column)->
    attributes = {}
    attributes[column] = obj.attributes[column]
    RewardTransaction.update(id: obj.id, data: attributes: attributes)
      .$promise.then (res)-> $scope.fetchRewards()

  $scope.toggleReferral = (obj, column)->
    attributes = {}
    attributes[column] = obj.attributes[column]
    Referral.update(id: obj.id, data: attributes: attributes)
      .$promise.then (res)-> $scope.fetchReferrals()


  $scope.exportReferrals = ->
    params = angular.extend(t: Session.getToken(), getReferralsFilters())
    $window.location.href = "#{BASE_ENDPOINT}/admin/referrals/csv?#{jQuery.param(params)}"

  $scope.exportRewards = ->
    params = angular.extend(t: Session.getToken(), getRewardsFilters())
    $window.location.href = "#{BASE_ENDPOINT}/admin/reward_transactions/csv?#{jQuery.param(params)}"

angular.module('client').controller('CustomerRewardsCtrl', Ctrl)
