angular.module('aGsn', [
  'ngRoute',
  'aGsn.controllers',
  'aGsn.services',
  'aGsn.directives',
  'aGsn.filters',
  'ngAnimate'
  ])
.config(function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '/templates/dashboard.html',
    controller: 'HomeController',
    resolve: {
      session: function(SessionService) {
        return SessionService.getCurrentUser();
      }
    }
  })
  .otherwise({
    redirectTo: '/'
  });
});

;
