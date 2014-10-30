angular.module('aGsn.directives', [])
// Our is-user-or-email validation
.directive('isUserOrEmail', function($http, $timeout, $filter, $q) {
  // we're checking using the api `is_user` if the user
  // input is already a user
  var isUser = function(input) {
    // We're returning a deferred promise
    var d = $q.defer();

    if (input) {
      $http({
        url: '/api/check/is_user',
        method: 'POST',
        data: { 'name': input }
      }).then(function(data) {
        if (data.status == 200){
          d.resolve(data.data);
        } else {
          d.reject(data.data);
        }
      });
    } else {
      d.reject("No input");
    }

    return d.promise;
  };

  var checking = null,
      emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, ele, attrs, ctrl) {
      // Anytime that our ngModel changes, we're going to check if the
      // value is a user with the function above
      // If it is a user, then our field will be valid, if it's not
      // check if the input is an email
      scope.$watch(attrs.ngModel, function(v) {
        if (checking) clearTimeout(checking);

        var value = scope.ngModel.$viewValue;

        checking = $timeout(function() {
          isUser(value).then(function(data) {
            if (data.success) {
              // Is a user
              checking = null;
              ctrl.$setValidity('isUserOrEmail', true);
            } else {
              // Is an email
              if (emailRegex.test(value)) {
                checking = null;
                ctrl.$setValidity('isUserOrEmail', true);
              } else {
                checking = null;
                ctrl.$setValidity('isUserOrEmail', false);
              }
            }
          });
          // Delay this check by 200 milliseconds to give
          // the keyboard time to settle down
        }, 200);
      });
    }
  };
})
.directive('articleListing', function() {
  return {
    restrict: 'EA',
    require: 'ngModel',
    scope: {
      'ngModel': '=',
      'onShare': '&'
    },
    templateUrl: 'templates/article_listing.html',
    link: function(scope, ele, attrs, ctrl) {
      scope.newShare = {recipient: ""};
      scope.share = function() {
        scope.onShare({
          'recipient': scope.newShare.recipient,
          'article': scope.ngModel
        });
      };
    }
  }
})
;