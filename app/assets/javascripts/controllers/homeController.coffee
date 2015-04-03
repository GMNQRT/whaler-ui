angular.module('whaler.controllers').controller 'HomeController', [
  '$scope',
  '$http',
  ($scope, $http) ->
    $scope.page = "home"
    console.log "lo"
    $http.get('http://localhost:3000/home/index.json').success((data, status, headers, config) ->
      $scope.list = data
      console.log data
    ).error (data, status, headers, config) ->
      console.log data

]