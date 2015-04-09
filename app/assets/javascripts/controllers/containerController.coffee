angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  '$http',
  ($scope, $http) ->
    $scope.page = "container"
    console.log "lo"
    $http.get('http://localhost:3000/container.json').success((data, status, headers, config) ->
      $scope.list = data
      console.log data
    ).error (data, status, headers, config) ->
      console.log data

]