angular.module('whaler.services').service 'ContainerService', [
  '$rootScope'
  '$timeout'
  'ContainerFactory'
  'WebSocket'
  ContainerService = (@$rootScope, @$timeout, @ContainerFactory, @WebSocket) ->
    return
]

ContainerService::getContainers = (force_reload = false) ->
  if force_reload
    return @containers = @ContainerFactory.query()
  return @containers ||= @ContainerFactory.query()

# Subscribe to events fired by this service
ContainerService::subscribe = ($scope, event_name, callback) ->
  handler = @$rootScope.$on("containerService.#{event_name}", callback)
  $scope.$on '$destroy', handler
  return handler

ContainerService::notify = (event_name, data...) ->
  @$rootScope.$emit "containerService.#{event_name}", data...

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

# Update containers' informations
ContainerService::update = ($event, container) ->
  if $event.status is 'create'
    @containers.unshift new @ContainerFactory(container)
  else
    for c, i in @containers when c.id == $event.id
      if $event.status is 'destroy'
        @containers.splice i, 1
      else
        @notify 'update', @containers[i] = container
      return
  return

ContainerService::select = (container) ->
  oldIdx             = @selectedIdx
  selectedIdx        = @containers.indexOf(container)
  @selectedContainer = @containers[selectedIdx]

  return null unless @selectedContainer
  if @containers[oldIdx]?.id != @selectedContainer.id
    @notify 'select', @selectedContainer
  return @selectedContainer
