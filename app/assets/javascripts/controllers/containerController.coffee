angular.module('whaler.controllers').controller 'ContainerController', [
  'ContainerFactory',
  '$routeParams',
  ContainerController = (@ContainerFactory, @$routeParams) ->
    @containers = @ContainerFactory.query()
    @show(@$routeParams['id'])
    return
]

ContainerController::show = (id) ->
  @container = @ContainerFactory.get({id: id})