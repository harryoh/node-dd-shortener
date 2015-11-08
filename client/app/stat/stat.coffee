'use strict'

angular.module 'nodeDdShortenerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'stat',
    url: '/stat'
    templateUrl: 'app/stat/stat.html'
    controller: 'StatCtrl'
