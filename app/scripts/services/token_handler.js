'use strict';

angular.module('aGsn.service')
  .factory('tokenHandler', function($rootScope, $http, $q, $location) {
    var token = null,
        currentUser;

    // https://gist.github.com/nblumoe/3052052
    var tokenWrapper = function(resource, action) {
      // copy original action
      resource['_' + action] = resource[action];
      // create new action wrapping the original and sending token
      resource[action] = function( data, success, error) {
        return resource['_' + action] (
          angular.extend({}, data || {}, {access_token: tokenHandler.get()}),
          success,
          error
        );
      };
    };

    var tokenHandler = {
     set: function(v) { token = v; },
     get: function() {
       if (!token) {
        $rootScope.$broadcast('event:unauthorized');
       } else {
        return token;
       }
     },
     wrapActions: function(resource, actions) {
       var wrappedResource = resource;
       for (var i=0; i < actions.length; i++) {
         tokenWrapper( wrappedResource, actions[i] );
       }
       return wrappedResource;
     }
    }

    getCurrentUser: function() {
      var d = $q.defer();
      if (currentUser) {
        d.resolve(currentUser);
      } else {
        $http({
          url: '/api/current_user',
          method: 'POST'
        }).then(function(data) {
          d.resolve(data.data);
        })
      }
      return d.promise;
    };

    return tokenHandler;
});
