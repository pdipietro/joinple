angular.module('aGsn.controller').controller('FrameController', [
  '$scope', function($scope) {
  $scope.today = new Date(); // Today's date
  $scope.name = "Ari Lerner"; // Our logged-in user's name
}]);