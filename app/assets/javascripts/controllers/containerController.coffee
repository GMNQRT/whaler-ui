angular.module('whaler.controllers').controller 'ContainerController', [
  'ContainerFactory',
  '$routeParams',
  ContainerController = (@ContainerFactory, @$routeParams) ->
    @containers = @ContainerFactory.query()

    return
]

ContainerController::show = (id) ->
  @container = @ContainerFactory.get({ id: @$routeParams['id'] })