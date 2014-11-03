'use strict';

angular.module('aGsn')
  .factory('tokenHandler', function($rootScope, $http, $q, $location) {
    var token = null,
        currentUser;

    var tokenHandler = {
     set: function(v) { token = v; },
     get: function() {
       if (!token) {
        $rootScope.$broadcast('event:unauthorized');
       } else {
        return token;
       }
     }
    };

    return tokenHandler;
  });
