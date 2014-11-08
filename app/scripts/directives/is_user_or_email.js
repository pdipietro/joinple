'use strict';

angular.module('aGsn.directive')
  .directive('isUserOrEmail', function($http, $timeout, $filter, $q) {
    // we are checking user the api 'is_user' if the user input is already a user
    var isUser = function(input) {
      // we are returning a deferred promise
      var d = $q.defer();
      if (input) {
        $http({
          url: '/check/is_user',
          method: 'POST',
          params: {
            auth_token: tokenHandler.get()
          },
          data: { 'name': input }
        }).then(function(data) {
          if (data.status === 200) {
            d.resolve(data.data);
          } else {
            d.reject(data.data);
          }
        });
      } else {
        d.reject('No input');
      }
      return d.promise;
  };

  var checking = null,
      emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, ele, attrs, ctrl) {
      // anytime that our ngModel changes, we're going to check if the
      // value is a user with the function above
      // If it is a user, then our field will be valid, if it is not
      // check the input for an email
      scope.$watch(attrs.ngModel, function(v) {
        if (checking) clearTimeout(checking);
        var value = scope.ngModel.$viewValue;
        checking = $timeout(function() {
          isUser(value).then(function(data) {
            if (data.success) {
              // is a user
              checking = null;
              ctrl.$setValidity('isUserOrEmail', true);
            } else {
              // is an email
              if (emailRegex.test(value)) {
                checking = null;
                ctrl.$setValidity('isUserOrEmail', true);
              } else {
                checking = null;
                ctrl.$setValidity('isUserOrEmail', false);
              }
            }
          });
          // delay the check of 200 msec to give the keyboard time
          // to settle down
        }, 200);
      });
    }
  };
  });
