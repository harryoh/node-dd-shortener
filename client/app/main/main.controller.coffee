'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'MainCtrl', ($scope, $http) ->

  $scope.shorten = ->
#    return  unless $scope.longUrl
    $scope.shortUrl = "http://url.5004.pe.kr/test"