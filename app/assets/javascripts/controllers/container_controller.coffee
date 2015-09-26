angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  'ContainerFactory',
  '$routeParams',
  'API',
  'StreamFactory'
  'WebSocket'
  ContainerController = (@$scope, @ContainerFactory, @$routeParams, @API, @StreamFactory, WebSocket) ->
    @selectedContainer = null
    @containers        = @ContainerFactory.query()
    @socketChannel     = WebSocket.subscribe('container')

    @socketChannel.bind 'event', (data) => @$scope.$apply(@updateContainer.call(@, data))

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
  return @unpause container if container.info.State.Paused
  @ContainerFactory.start { id: container.id }

ContainerController::stop = (container) ->
  @ContainerFactory.stop { id: container.id }

ContainerController::pause = (container) ->
  @ContainerFactory.pause { id: container.id }

ContainerController::unpause = (container) ->
  @ContainerFactory.unpause { id: container.id }

ContainerController::restart = (container) ->
  @ContainerFactory.restart { id: container.id }

ContainerController::delete = (container) ->
  @ContainerFactory.delete { id: container.id }, (res) =>
    @containers.splice @containers.indexOf(container), 1

# Update container informations throught websocket
ContainerController::updateContainer = (data) ->
  for container, i in @containers when container.id == data.event.id
    if data.event.status is 'destroy'
      @containers.splice i, 1
    else
      @containers[i] = data.container
    return
  return

# Display container informations on right pane
ContainerController::showMoreInfo = (container) ->
  angular.element('#right-pane').addClass('active')
  @selectedContainer = @containers.indexOf(container)
