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
  .module('aGsn', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngMessages',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'aGsn.controller',
    'aGsn.service',
    'aGsn.directive',
    'aGsn.filter',
    'oauth'
//    'ngCookies',
//    'ui.router',

  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  })

  .config(function(authProvider) {

    // routing configuration and other stuff
    // ...

    authProvider.init({
      domain: 'mydomain.auth0.com',
      clientID: 'myClientID',
      loginUrl: '/login'
    });
  })

  .run(function(auth) {
    auth.hookEvents();
  })

  angular.module('newProjectApp').config(function($locationProvider) {
    $locationProvider.html5Mode(true).hashPrefix('!');
  })

;


