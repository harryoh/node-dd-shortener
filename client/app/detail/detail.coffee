'use strict'

angular.module 'nodeDdShortenerApp'
.config ($stateProvider) ->
  $stateProvider.state 'detail',
    url: '/:shortenId/detail'
    templateUrl: 'app/detail/detail.html'
    controller: 'DetailCtrl'
