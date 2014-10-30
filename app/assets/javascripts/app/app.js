angular
  .module('aGsn',
    [
        'ngAnimate',
        'ngRoute',
    //    'ui.router',
    //    'templates',
    //    'ngResource',
        'aGsn.controllers',
        'aGsn.services',
    //    'aGsn.directives',
  //      'aGsn.filters'
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

/*    })

    .config(function($stateProvider,
      $urlRouterProvider,
      $locationProvider
      ){
        // Route and States
        $stateProvider.state('home',
        {
            url: '/',
            templateUrl: 'dashboard.html',
            controller: 'HomeController'
        })
        //parent for the below child states
        .state('dashboard',
        {
            abstract: true,
            url: '/dashboard',
            templateUrl: 'dashboard/layout.html'
        })
          //the default route when someone hits dashboard
          .state('dashboard.one',
          {
              url: '',
              templateUrl: 'dashboard/one.html'
          })
          //this is /dashboard/two
          .state('dashboard.two',
          {
              url: '/two',
              templateUrl: 'dashboard/two.html'
          })
          //this is /dashboard/three
          .state('dashboard.three',
          {
              url: '/three',
              templateUrl: 'dashboard/three.html'
          })
        //parent for the below child states
        .state('language',
        {
            url: '/language',
            templateUrl: 'language/layout.html'
        })
        //the default route when someone hits dashboard
          .state('language.index',
          {
              url: '/index',
              templateUrl: 'language/index.html'
          })
          //this is /dashboard/two
          .state('language.view',
          {
              url: '/view',
              templateUrl: 'language/view.html'
          })
          //this is /dashboard/three
          .state('language.edit',
          {
              url: '/edit',
              templateUrl: 'language/edit.html'
          })

      ;
        // default fallback route
        $urlRouterProvider.otherwise('/');
        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(true);
*/


