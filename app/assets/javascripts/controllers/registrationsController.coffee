angular.module('whaler.controllers').controller 'RegistrationsController', [
  '$scope',
  '$http',
  ($scope, $http) ->
    $http.get('http://localhost:3000/users/sign_in.json').success((data, status, headers, config) ->
      $scope.values = data
      console.log data
    ).error (data, status, headers, config) ->
      console.log data
]