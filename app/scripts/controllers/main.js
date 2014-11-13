'use strict';

/**
 * @ngdoc function
 * @name gsnApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the gsnApp
 */
angular.module('aGsn.controller')
  .controller('MainCtrl', function ($scope, $http, ArticleService) {
    $scope.currentUser = {};
    ArticleService.getLatestFeed()
      .then(function(data) {
        $scope.articles = data;
      });
  });
