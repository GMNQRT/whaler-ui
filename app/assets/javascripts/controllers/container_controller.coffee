angular.module('whaler.controllers').controller 'ContainerController', [
  'ContainerFactory',
  '$routeParams',
  ContainerController = (@ContainerFactory, @$routeParams) ->
    @containers = @ContainerFactory.query()

    return
]

ContainerController::show = () ->
  @container = @ContainerFactory.get { id:  @$routeParams['id'] }

ContainerController::start = (container) ->
  @ContainerFactory.start { id: container.id }, (res) ->
    angular.extend container, res

ContainerController::stop = (container) ->
  @ContainerFactory.stop { id: container.id }, (res) ->
    angular.extend container, res

ContainerController::pause = (container) ->
  @ContainerFactory.pause { id: container.id }, (res) ->
    angular.extend container, res

ContainerController::unpause = (container) ->
  @ContainerFactory.unpause { id: container.id }, (res) ->
    angular.extend container, res

ContainerController::restart = (container) ->
  @ContainerFactory.restart { id: container.id }, (res) ->
    angular.extend container, res

ContainerController::delete = (container) ->
  @ContainerFactory.delete { id: container.id }, (res) ->
    angular.extend container, res