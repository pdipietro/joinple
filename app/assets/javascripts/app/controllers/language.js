angular.module('aGsn.controllers')
    .controller('LanguageCtrl', function ($scope) {
        $scope;
    })

    .factory('Language', function($resource) {
              return $resource('/api/language/:id', { id: '@_id' },
                {   update: { method: 'PUT' }})
      })


;

