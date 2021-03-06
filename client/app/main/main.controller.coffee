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
        longUrl: data.longUrl
        createdAt: moment().format()
        clicked: 0

      delete $scope.longUrl

    .error (e) ->
      $scope.message = "Error: #{e}"
      delete $scope.shortUrl

  $scope.currentPage = 1
  $scope.pagePerNumber = 20
  $scope.getList = ->
    $http.get '/api/1.0/url/list',
      params:
        page: $scope.currentPage
        pagePerNumber: $scope.pagePerNumber
    .success (data, status) ->
      return  unless data
      $scope.totalUrl = data.total
      $scope.urls = data.urls

  $http.get '/api/1.0/url/list'
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.urls = data.urls

  $scope.host = $window.location.origin


.filter 'fromNow', ->
  (date) ->
    moment(date).fromNow()