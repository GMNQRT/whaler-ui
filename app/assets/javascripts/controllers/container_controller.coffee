angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope'
  '$timeout'
  'WebSocket'
  'ContainerService'
  ContainerController = (@$scope, @$timeout, @WebSocket, @ContainerService) ->
    @logs = new Array()

    return
]

ContainerController::indexAction = () ->
  @$scope.$on '$destroy', @unwatch

  if @ContainerService.containers?[@ContainerService.selectedContainer]?.active
    @select @ContainerService.containers[@ContainerService.selectedContainer]


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

  @containerChannel.bind 'log', (data) =>
    @logs.push(data.message)
    @$scope.$apply()
  return
