angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  'ContainerFactory',
  '$routeParams',
  'API',
  'StreamFactory'
  'WebSocket'
  ContainerController = (@$scope, @ContainerFactory, @$routeParams, @API, @StreamFactory, @WebSocket) ->
    @term = ''
    @selectedContainer = null
    @containers = @ContainerFactory.query()

    return
]

ContainerController::show = () ->
  @logs = new Array()
  @container = @ContainerFactory.get { id:  @$routeParams['id'] }

  source = @StreamFactory.listen("#{@API.baseUrl()}container/#{@$routeParams['id']}/logs.json")
  source.$on 'logs', (message) =>
    @logs.push(message)
  , @$scope
  @$scope.$on '$destroy', source.destroy

  return

ContainerController::start = (container) ->
  console.log "start"
  if container.info.State.Paused
    @unpause container
  else
    @ContainerFactory.start { id: container.id }, (res) ->
      angular.extend container.info.State, res.info.State

ContainerController::stop = (container) ->
  console.log "stop"
  @ContainerFactory.stop { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::pause = (container) ->
  console.log "pause"
  @ContainerFactory.pause { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::unpause = (container) ->
  console.log "unpause"
  @ContainerFactory.unpause { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::restart = (container) ->
  console.log "restart"
  @ContainerFactory.restart { id: container.id }, (res) ->
    angular.extend container.info.State, res.info.State

ContainerController::delete = (container) ->
  console.log "delete"
  @ContainerFactory.delete { id: container.id }, (res) =>
    @containers.splice @containers.indexOf(container), 1

ContainerController::setEnv = (data) ->
  console.log data
  # @ContainerFactory.delete { id: container.id }, (res) =>
    # @containers.splice @containers.indexOf(container), 1

ContainerController::removeEnv = (data) ->
  console.log data

ContainerController::addEnv = (data) ->
  console.log data
  # @ContainerFactory.delete { id: container.id }, (res) =>
    # @containers.splice @containers.indexOf(container), 1

ContainerController::select = (container) ->
  angular.element('#right-pane').addClass('active')
  @selectedContainer = container
  console.log container


ContainerController::search= (val, $event) ->
  $event?.preventDefault()
  return if !val || val.length == 0

  @ContainerFactory.search { term: val }, (container) =>
    @containers = containers
