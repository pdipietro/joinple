angular.module('aGsn.filter', [])
.filter('toDate', function() {
  return function(input) {
    return new Date(input);
  }
})
