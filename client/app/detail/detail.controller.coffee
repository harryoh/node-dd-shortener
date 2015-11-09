'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'DetailCtrl', ($scope, $http, $window, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}"
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.history = data.history
