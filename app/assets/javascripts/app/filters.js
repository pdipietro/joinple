angular.module('aGsn.filters', [])
.filter('toDate', function() {
  return function(input) {
    return new Date(input);
  }
})