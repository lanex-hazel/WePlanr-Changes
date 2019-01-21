angular.module('client').directive 'mobileIntroFavourites',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/mobile-favourites.html'

angular.module('client').directive 'introFavourites',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/favourites.html'

angular.module('client').directive 'onboardCard1',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/card1.html'

angular.module('client').directive 'onboardsCard2',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/card2.html'

angular.module('client').directive 'onboardsCard3',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/card3.html'

angular.module('client').directive 'onboardSuggestion',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/suggest.html'

angular.module('client').directive 'onboardCategory',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/category.html'

angular.module('client').directive 'onboardSearch',->
  restrict: "E"
  replace: true
  templateUrl: 'app/pages/main/intro/partials/search.html'