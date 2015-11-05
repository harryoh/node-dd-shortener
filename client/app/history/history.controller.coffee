'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'HistoryCtrl', ($scope, $http, $window) ->
  $http.get '/api/1.0/history'
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.history = data.history
