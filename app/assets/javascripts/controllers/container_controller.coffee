angular.module('whaler.controllers').controller 'ContainerController', [
  'ContainerFactory',
  '$routeParams',
  ContainerController = (@ContainerFactory, @$routeParams) ->
    @containers = @ContainerFactory.query()

    return
]

ContainerController::show = (id) ->
  @container = @ContainerFactory.get({ id: @$routeParams['id'] })

ContainerController::start = (id) ->
  @container = @ContainerFactory.start({ id: @$routeParams['id'] })

ContainerController::stop = (id) ->
  @container = @ContainerFactory.stop({ id: @$routeParams['id'] })

ContainerController::pause = (id) ->
  @container = @ContainerFactory.pause({ id: @$routeParams['id'] })

ContainerController::unpause = (id) ->
  @container = @ContainerFactory.unpause({ id: @$routeParams['id'] })

ContainerController::restart = (id) ->
  @container = @ContainerFactory.restart({ id: @$routeParams['id'] })

ContainerController::delete = (id) ->
  @container = @ContainerFactory.delete({ id: @$routeParams['id'] })