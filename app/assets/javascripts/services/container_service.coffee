angular.module('whaler.services').service 'ContainerService', [
  '$rootScope'
  '$timeout'
  '$routeParams'
  'ContainerFactory'
  'WebSocket'
  ContainerService = (@$rootScope, @$timeout, @$routeParams, @ContainerFactory, @WebSocket) ->
    @containers = @ContainerFactory.query()
    return
]

ContainerService::reload = () ->
  @containers = @ContainerFactory.query()

ContainerService::bindTo = (@$scope) ->
  @containersChannel = @WebSocket.subscribe('container') unless @containersChannel # Watch containers events
  @containersChannel.bind 'event', (data) => @$scope.$apply(@updateContainer.call(@, data)) if @containers

  @$scope.$on '$destroy', () =>
    @WebSocket.unsubscribe 'container'


# Subscribe to events fired by this service
ContainerService::subscribe = (event_name, callback) ->
  handler = @$scope.$on("containerService.#{event_name}", callback)
  @$scope.$on '$destroy', handler
  return handler

ContainerService::notify = (event_name, data...) ->
  @$scope.$emit "containerService.#{event_name}", data...

ContainerService::start = (container) ->
  return @unpause container if container.info.State.Paused
  @ContainerFactory.start { id: container.id }

ContainerService::stop = (container) ->
  @ContainerFactory.stop { id: container.id }

ContainerService::pause = (container) ->
  @ContainerFactory.pause { id: container.id }

ContainerService::unpause = (container) ->
  @ContainerFactory.unpause { id: container.id }

ContainerService::restart = (container) ->
  @ContainerFactory.restart { id: container.id }

ContainerService::remove = (container) ->
  @ContainerFactory.delete { id: container.id }

# Update containers' informations through websocket
ContainerService::updateContainer = (data) ->
  if data.event.status is 'create'
    @containers.push data.container
  else
    for container, i in @containers when container.id == data.event.id
      if data.event.status is 'destroy'
        @containers.splice i, 1
      else
        @containers[i]      = data.container
        @containers[i].tilt = true
        @containers[@selectedContainer].active = true if @containers[@selectedContainer]?.id == container.id
      return
  return

# Display container informations on right pane
ContainerService::select = (container) ->
  if @containers[@selectedContainer]
    return if container.id == @containers[@selectedContainer].id # Quit if same container is selected
  @selectedContainer = @containers.indexOf(container)

  if @containers[@selectedContainer]
    @notify 'select', @containers[@selectedContainer]
