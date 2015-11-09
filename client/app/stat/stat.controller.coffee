'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'StatCtrl', ($scope, $http) ->
  $http.get '/api/1.0/history'
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.history = data.history

.controller 'CreatedCtrl', ($scope, $http) ->
  $http.get '/api/1.0/history/created'
  .success (data, status) ->
    $scope.createdList = data

.controller 'BrowserCtrl', ($scope, $http) ->
  $http.get '/api/1.0/history/browser'
  .success (data, status) ->
    $scope.browserList = data

.controller 'CountryCtrl', ($scope, $http) ->
  $http.get '/api/1.0/history/country'
  .success (data, status) ->
    $scope.countryList = data

.controller 'PlatformCtrl', ($scope, $http) ->
  $http.get '/api/1.0/history/platform'
  .success (data, status) ->
    $scope.platformList = data
