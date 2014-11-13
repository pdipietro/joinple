'use strict';

angular.module('aGsn.controller')
  .controller('LoginCtrl', function ($scope, $location, $http, tokenHandler) {

    $scope.signup = function() {
      $http({
        url: '/api/users',
        method: 'POST',
        data: {
          user: $scope.user
        }
      }).success(function(data) {
        tokenHandler.set( data.auth_token );
        $location.path('/');
      }).error(function(reason) {
        $scope.user.errors = reason;
      });
    };

    $scope.login = function() {
      $http({
        url: '/api/users/sign_in',
        method: 'POST',
        data: {
          user: $scope.user
        }
      }).success(function(data) {
        if (data.success) {
          $scope.ngModel = data.data.data;
          tokenHandler.set(data.data.auth_token);
          $location.path('/');
        } else {
          $scope.ngModel = data;
          $scope.user.errors = data.info;
        }
      }).error(function(msg) {
        $scope.user.errors = 'Something is wrong with the service. Please try again';
      });

    };

  });
