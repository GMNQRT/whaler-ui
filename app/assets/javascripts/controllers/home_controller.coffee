angular.module('whaler.controllers').controller 'HomeController', [
  '$scope',
  '$http',
  'API',
  'ContainerService'
  HomeController = (@$scope, @$http, @API, @ContainerService) ->
    @ContainerService.initialize @$scope

    return
]

HomeController::getInfo = () ->
  @$http.get(@API.baseUrl() + 'home/index.json').success (data, status, headers, config) =>
    @values = data
