angular.module('aGsn.controllers',[])
  .controller('HomeController',
    function($scope, ArticleService)
      {
//    , session, SessionService, ArticleService) {
//      $scope.user = session.user;
        ArticleService.getLatestFeed()
        .then(function(data) {
          $scope.articles = data;
        })
    })

;
