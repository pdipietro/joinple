angular.module('aGsn.controllers', [])
.controller('HomeController', function($scope, session, SessionService, ArticleService, Share) {
  ArticleService.getLatestFeed()
  .then(function(data) {
    $scope.articles = data;
  });
  $scope.user = session.user;
  $scope.newShare = {
    recipient: ''
  };
  $scope.share = function(recipient, article) {
    var share = new Share({
      url: article.link,
      from_user: $scope.user.id,
      user: recipient
    });
    share.$save();
    $scope.newShare.recipient = '';
  }
});