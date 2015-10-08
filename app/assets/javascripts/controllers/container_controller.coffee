angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  '$location',
  'ContainerFactory',
  '$routeParams',
  'API',
  'StreamFactory'
  'WebSocket'
  ContainerController = (@$scope, @$location, @ContainerFactory, @$routeParams, @API, @StreamFactory, @WebSocket) ->
    @selectedContainer = null
    @containers        = @ContainerFactory.query()
    @containersChannel = @WebSocket.subscribe('container')

    @containersChannel.bind 'event', (data) => @$scope.$apply(@updateContainer.call(@, data))

    return
]


ContainerController::show = () ->
  container_id     = @$routeParams['id']
  containerChannel = @WebSocket.subscribe "container.#{container_id}"
  @logs            = new Array()

  @WebSocket.trigger 'container.watchlogs', container: container_id
  containerChannel.bind "log", (chunk) =>
    @logs.push chunk
    @$scope.$apply()

  @$scope.$on '$destroy', () =>
    @WebSocket.trigger 'container.unwatchlogs', container: container_id
    @WebSocket.unsubscribe "container.#{@$routeParams['id']}"

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

ContainerController::remove = (container) ->
  @ContainerFactory.delete { id: container.id }

# Update containers' informations through websocket
ContainerController::updateContainer = (data) ->
  if data.event.status is 'create'
    @containers.push data.container
  else
    for container, i in @containers when container.id == data.event.id
      if data.event.status is 'destroy'
        @containers.splice i, 1
      else
        @containers[i] = data.container
      return
  return

ContainerController::moreInfo = (container) ->
  @$location.path "/container/#{container.id}"
  return

# Display container informations on right pane
ContainerController::showRightPane = (container) ->
  angular.element('#right-pane').addClass('active')
  @selectedContainer = @containers.indexOf(container)

# Hide right pane
ContainerController::hideRightPane = () ->
  angular.element('#right-pane').removeClass('active')
  return
