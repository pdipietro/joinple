'use strict';

/**
 * @share_service overview
 * @name gsnApp
 * @description
 * # gsnApp
 *
 * Module for the share_service.
 */

 angular.module('aGsn.factory').
  factory('ShareService', function($resource, $q, tokenHandler) {
    var Share = $resource('/api/shares/:id',
      {id: '@id'},
      {}
      );
    tokenHandler.wrapActions(Share, ['save']);
    return Share;
  })

  ;