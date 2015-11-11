angular.module('whaler.controllers').controller 'ContainerController', [
  '$location'
  '$scope'
  '$timeout'
  'WebSocket'
  'ContainerService'
  ContainerController = (@$location, @$scope, @$timeout, @WebSocket, @ContainerService) ->
    @logs = new Array()
    return
]

ContainerController::indexAction = () ->
  prevHash = @$location.hash()

  @select @selectByHash() if @$location.hash()

  @$scope.$on '$destroy', @unwatch
  @$scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) => # Select active card on history back
    @select @selectByHash() if @$location.hash() != @prevContainer?.id


# Select container by current hash in URL
ContainerController::selectByHash = () ->
  for container in @ContainerService.containers when container.id == @$location.hash()
    @ContainerService.select container
    return container


# Unbind from container channel
ContainerController::unwatch = () ->
  @WebSocket.unsubscribe(@containerChannel.name) if @containerChannel
  @prevContainer = @containerChannel = null


# Display container informations on right pane
ContainerController::select = (container) ->
  @unwatch() if @prevContainer || !container

  @logs             = new Array()
  @containerChannel = @WebSocket.subscribe("container.:container", container: container.info.Name.substr(1)) # Watch containers logs
  @prevContainer    = container

  @$location.hash(container.id)
  @containerChannel.bind 'log', (data) =>
    @logs.push(data.message)
    @$scope.$apply()
