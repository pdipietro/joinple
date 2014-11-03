'use strict';

/**
 * @ngdoc overview
 * @name aGsnApp
 * @description
 * # aGsnApp
 *
 * Main module of the application.
 */
angular
  .module('aGsnApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/login', {
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  })
  .config(function($httpProvider) {
    var interceptor = ['$rootScope', '$location', '$q',
    function($scope, $location, $q) {
      var success = function(resp) { return resp; },
        err = function(resp) {
          if (resp.status === 401) {
            var d = $q.defer();
            $scope.$broadcast('event.unauthorized');
            return d.promise;
          }
          return $q.reject(resp);
        };
      return function(promise) {
        return promise.then(success,err);
      };
    }];
    $httpProvider.responseInterceptors.push(interceptor);
  })
  .run(function($rootScope, $http, $location, tokenHandler) {
    $rootScope.$on('event:unauthorized', function(evt) {
      $location.path('/login');
    });
  })
  ;
