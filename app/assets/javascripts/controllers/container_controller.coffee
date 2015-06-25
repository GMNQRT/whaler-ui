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
    angular.extend container.info.State, res.info.State

ContainerController::stop = (container) ->
  @ContainerFactory.stop { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::pause = (container) ->
  @ContainerFactory.pause { id: container.id }, (res) ->
    console.log container, res
    angular.extend container.info.State, res.info.State

ContainerController::unpause = (container) ->
  @ContainerFactory.unpause { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::restart = (container) ->
  @ContainerFactory.restart { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::delete = (container) ->
  @ContainerFactory.delete { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State