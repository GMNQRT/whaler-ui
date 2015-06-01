angular.module('whaler.controllers').controller 'HomeController', [
  '$scope',
  '$http',
  '$location',
  ($scope, $http, $location) ->
    $http.get('http://localhost:3000/home/index.json').success((data, status, headers, config) ->
      $scope.values = data
    ).error (data, status, headers, config) ->
      console.log data
      if status == 401
        $location.path('/users/sign_in');
]