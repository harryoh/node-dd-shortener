'use strict'

angular.module 'nodeDdShortenerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'history',
    url: '/history'
    templateUrl: 'app/history/history.html'
    controller: 'HistoryCtrl'
