'use strict';

/**
 * @ngdoc overview
 * @name gsnApp
 * @description
 * # gsnApp
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
    'aGsn.filter'
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
      .when('/login', {
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
