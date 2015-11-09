'use strict'

angular.module 'nodeDdShortenerApp'
.controller 'DetailCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}"
  .success (data, status) ->
    return  unless data
    $scope.totalUrl = data.total
    $scope.history = data.history

.controller 'ClicksCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}/clicks"
  .success (data, status) ->
    $scope.clickList = data

.controller 'BrowserCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}/browser"
  .success (data, status) ->
    $scope.browserList = data

.controller 'CountryCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}/country"
  .success (data, status) ->
    $scope.countryList = data

.controller 'ReferrerCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}/referrer"
  .success (data, status) ->
    $scope.referrerList = data

.controller 'RemoteIpCtrl', ($scope, $http, $stateParams) ->
  $http.get "/api/1.0/history/#{$stateParams.shortenId}/remoteIp"
  .success (data, status) ->
    $scope.remoteIpList = data
