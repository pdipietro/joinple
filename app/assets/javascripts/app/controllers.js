angular.module('aGsn.controllers',[])
  .controller('HomeController',
    function($scope, session, SessionService, ArticleService, Share)
      {
//    , session, SessionService, ArticleService) {
        $scope.user = session.user;
        ArticleService.getLatestFeed()
        .then(function(data) {
          $scope.articles = data;
        })
    })

;
