angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  'ContainerFactory',
  '$routeParams',
  'API',
  'StreamFactory'
  ContainerController = (@$scope, @ContainerFactory, @$routeParams, @API, @StreamFactory) ->
    @term = ''
    @containers = @ContainerFactory.query()

    return
]

ContainerController::show = () ->
  @logs = new Array()
  @container = @ContainerFactory.get { id:  @$routeParams['id'] }

  source = @StreamFactory.listen("#{@API.baseUrl()}container/#{@$routeParams['id']}/logs.json");
  source.$on 'logs', (message) =>
    @logs.push(message)
  , @$scope
  @$scope.$on '$destroy', source.destroy

  return

ContainerController::start = (container) ->
  @ContainerFactory.start { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::stop = (container) ->
  @ContainerFactory.stop { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::pause = (container) ->
  @ContainerFactory.pause { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::unpause = (container) ->
  @ContainerFactory.unpause { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::restart = (container) ->
  @ContainerFactory.restart { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::delete = (container) ->
  @ContainerFactory.delete { id: container.id }, (res) =>
    @containers.splice @containers.indexOf(container), 1

ContainerController::search= (val, $event) ->
  $event?.preventDefault()
  return if !val || val.length == 0

  @ContainerFactory.search { term: val }, (container) =>
    @containers = containers
