angular.module('whaler.controllers').controller 'RegistrationsController', [
  '$scope',
  '$http',
  ($scope, $http) ->
    $http.delete('http://localhost:3000/users/sign_out.json').success((data, status, headers, config) ->
      $scope.values = data
      console.log data
    ).error (data, status, headers, config) ->
      console.log data
]