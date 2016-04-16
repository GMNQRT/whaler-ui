angular.module('whaler.controllers').controller 'HomeController', [
  '$scope'
  '$http'
  '$location'
  'API'
  'ContainerService'
  HomeController = (@$scope, @$http, @$location, @API, @ContainerService) ->
    @ContainerService.subscribe @$scope, 'select', ($event, container) =>
      @$location.path('/container') if @$location.hash()
    return
]

HomeController::getInfo = () ->
  @$http.get(@API.baseUrl() + 'home/index.json').success (data, status, headers, config) =>
    @values = data
