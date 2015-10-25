angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  '$timeout',
  'ContainerFactory',
  '$routeParams',
  'WebSocket'
  ContainerController = (@$scope, @$timeout, @ContainerFactory, @$routeParams, @WebSocket) ->
    @views =
      container: '/partials/containers/show.html'

    return
]


ContainerController::indexAction = () ->
  @containers = @ContainerFactory.query () =>
    @select @containers[0]
    @containersChannel = @WebSocket.subscribe('container')

    @containersChannel.bind 'event', (data) => @$scope.$apply(@updateContainer.call(@, data))

    @$scope.$on '$destroy', () =>
      @WebSocket.unsubscribe 'container'
      if @containers[@selectedContainer] and @containers[@selectedContainer].active
        @WebSocket.unsubscribe 'container.:container', container: @containers[@selectedContainer].id
  return

ContainerController::showAction = () ->
  @container = @ContainerFactory.get id: @$routeParams['id'], (container) =>
    containerChannel = @WebSocket.subscribe 'container.:container', container: container.id
    @logs            = new Array()

    containerChannel.bind "log", (chunk) =>
      @logs.push chunk
      @$scope.$apply()

    @$scope.$on '$destroy', () => @WebSocket.unsubscribe 'container.:container', container: container.id
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
        @containers[i]      = data.container
        @containers[i].tilt = true
        @containers[@selectedContainer].active = true if @containers[@selectedContainer].id == container.id
      return
  return


# Display container informations on right pane
ContainerController::select = (container) ->
  if @containers[@selectedContainer]
    # Quit if click on same container
    return if container.id == @containers[@selectedContainer].id
    # Else unbind and disable previous selected container
    @WebSocket.unsubscribe 'container.:container', container: @containers[@selectedContainer].id
    @containers[@selectedContainer].active = false
    @containerChannel.destroy() if @containerChannel

  @logs              = new Array()
  @selectedContainer = @containers.indexOf(container)

  if @containers[@selectedContainer]
    @containers[@selectedContainer].active = true

    @$timeout.cancel @logTimeout if @logTimeout
    # Subscribes to 'log' after 1s to prevent quick switch between containers to throw too many request
    @logTimeout = @$timeout () =>
      @logs             = new Array()
      @containerChannel = @WebSocket.subscribe 'container.:container', container: container.id

      @containerChannel.bind 'log', (chunk) =>
        @logs.push chunk
        @$scope.$apply()
    , 1000
  return
