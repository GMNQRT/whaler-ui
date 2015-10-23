angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope',
  '$location',
  'ContainerFactory',
  '$routeParams',
  'WebSocket'
  '$rootScope'
  ContainerController = (@$scope, @$location, @ContainerFactory, @$routeParams, @WebSocket, $rootScope) ->
    @views =
      container: '/partials/containers/show.html'

    return
]


ContainerController::indexAction = () ->
  @selectedContainer = null
  @containers        = @ContainerFactory.query () =>
    @containersChannel = @WebSocket.subscribe('container')

    @containersChannel.bind 'event', (data) => @$scope.$apply(@updateContainer.call(@, data))

    @$scope.$on '$destroy', () => @WebSocket.unsubscribe 'container'
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
        @containers[i] = data.container
      return
  return

ContainerController::moreInfo = (container) ->
  @$location.path "/container/#{container.id}"
  return

# Display container informations on right pane
ContainerController::select = (container) ->
  @containers[@selectedContainer].active = false if @containers[@selectedContainer]
  @selectedContainer = @containers.indexOf(container)
  @containers[@selectedContainer].active = true if @containers[@selectedContainer]
