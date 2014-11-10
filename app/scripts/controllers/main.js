'use strict';

/**
 * @ngdoc function
 * @name gsnApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the gsnApp
 */
angular.module('gsnApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
