'use strict';

/**
 * @ngdoc overview
 * @name aGsn
 * @description
 * # aGsn
 *
 * Main module of the application.
 */

angular.module('aGsn.controller',[]);
angular.module('aGsn.service',[]);
angular.module('aGsn.filter',[]);
angular.module('aGsn.directive',[]);

angular
  .module('aGsn',
    [
        'ngAnimate',
        'ngRoute',
//        'ngCookies',
        'ngResource',
//        'ngSanitize',
//        'ngTouch',
        'aGsn.controller',
        'aGsn.service',
        'aGsn.directive',
        'aGsn.filter'
    //    'ui.router',
    //    'templates',
    //    'ngResource',
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
      .when('/main', {
        templateUrl: 'views/main.html',
        controller: 'MainController'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutController'
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


