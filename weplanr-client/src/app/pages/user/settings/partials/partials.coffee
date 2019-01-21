angular.module('client').directive 'userReferral',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/settings/partials/user_referral.html'

angular.module('client').directive 'userRewards',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/user/settings/partials/user_rewards.html'
