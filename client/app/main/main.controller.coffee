'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'MainCtrl', ($scope, $http, $window) ->
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

      $scope.urls.unshift
        shortenId: data.shortUrl.split(/[\/ ]+/).pop()
        longUrl: $scope.longUrl
        createdAt: moment().format()
        clicked: 0

    .error (e) ->
      $scope.message = "Error: #{e}"
      delete $scope.shortUrl

  $http.get '/api/1.0/url/list'
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.urls = data.urls

  $scope.host = $window.location.origin


.filter 'fromNow', ->
  (date) ->
    moment(date).fromNow()