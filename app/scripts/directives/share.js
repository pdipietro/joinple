'use strict';

angular.module('aGsn.directive')
  .directive('share', function($http, $timeout, ShareService, tokenHandler) {
    return {
      restrict: 'A',
      require: 'ngModel',
      templateUrl: 'views/share.html',
      scope: {
        ngModel: '=',
        onShare: '&'
      },
      link: function(scope, attrs, ele) {
        scope.newShare = {recipient: ''};
        scope.showPending = false;
        scope.showConfirmation = false;
        //our share function will take an article and use our share service,
        // which is a $resource, and call save on the current User
        scope.share = function() {
          scope.newShare = {recipient: ''};
          var share = new ShareService({
            url: scope.ngModel.url,
            from_user: tokenHandler.getCurrentUser().id,
            to_user: scope.newShare.recipient
          });
          // Show pending
          scope.showPending = true;
          share.$save(function(s) {
            //show confirmation for 2 seconds
            scope.showPending = !(scope.showConfirmation = true);
            $timeout(scope.hideConfirmation, 2000);
          });
        };
        scope.hideConfirmation = function() {
          scope.showConfirmation = false;
        };
      }
    };
});
