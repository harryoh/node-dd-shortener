'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'MainCtrl', ($scope, $http, $element) ->
  $scope.longUrl = 'http://5004.pe.kr/IamlongURL'
  $scope.shorten = ->
    return  unless $scope.longUrl
    $http.post '/api/1.0/url',
      'longUrl': $scope.longUrl

    .success (data, status) ->
      $scope.shortUrl = data.shortUrl
      if data.executionTime
        $scope.message =
          " #{data.executionTime.sec}sec " +
          " #{data.executionTime.ms//1000000}ms "

    .error (e) ->
      $scope.message = "Error: #{e}"
