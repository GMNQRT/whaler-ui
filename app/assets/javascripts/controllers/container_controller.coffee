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
  @$scope.$on '$destroy', @unwatch
  @$scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) =>
    @selectByHash() if @$location.hash()

  @selectByHash() if @$location.hash()


# Select container by current hash in URL
ContainerController::selectByHash = () ->
  for container in @ContainerService.containers when container.id == @$location.hash()
    @ContainerService.select container
    return


# Unbind from container channel
ContainerController::unwatch = () ->
  @WebSocket.unsubscribe(@containerChannel.name) if @containerChannel
  @prevContainer = @containerChannel = null


# Display container informations on right pane
ContainerController::select = (container) ->
  @unwatch if @prevContainer

  @logs             = new Array()
  @containerChannel = @WebSocket.subscribe("container.:container", container: container.info.Name.substr(1)) # Watch containers logs
  @prevContainer    = container

  @$location.hash(container.id)
  @containerChannel.bind 'log', (data) =>
    @logs.push(data.message)
    @$scope.$apply()
  return
