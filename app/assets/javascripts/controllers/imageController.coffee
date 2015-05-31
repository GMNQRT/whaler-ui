angular.module('whaler.controllers').controller 'ImageController', [
  '$scope',
  '$http',
  'ImageFactory',
  ($scope, $http, ImageFactory) ->
    console.log 'ImageController'

    console.log ImageFactory
    $factories = ImageFactory.query () ->
    # $http.get('http://localhost:3000/images.json').success((data, status, headers, config) ->
    #   $scope.values = data
    #   console.log data
    # ).error (data, status, headers, config) ->
    #   console.log data
]