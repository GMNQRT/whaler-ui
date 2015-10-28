angular.module('whaler.controllers').controller 'ContainerController', [
  '$scope'
  '$timeout'
  '$routeParams'
  'WebSocket'
  'ContainerService'
  ContainerController = (@$scope, @$timeout, @$routeParams, @WebSocket, @ContainerService) ->
    @ContainerService.initialize @$scope
    @ContainerService.subscribe 'select', @select.bind(@)
    return
]


ContainerController::indexAction = () ->
  @$scope.$on '$destroy', () =>
    if @ContainerService.containers[@ContainerService.selectedContainer]?.active
      @WebSocket.unsubscribe 'container.:container', container: @ContainerService.containers[@ContainerService.selectedContainer].id


  if @ContainerService.containers?[@ContainerService.selectedContainer]?.active
    @select null, @ContainerService.containers[@ContainerService.selectedContainer], null


# Display container informations on right pane
ContainerController::select = ($event, container, prevContainer) ->
  if @containerChannel
    @WebSocket.unsubscribe 'container.:container', container: prevContainer.id
    @containerChannel.destroy()
    # @containerChannel = null

  @logs = new Array()
  @$timeout.cancel @logTimeout if @logTimeout
  # Subscribes to 'log' after 1s to prevent quick switch between containers to throw too many request
  @logTimeout = @$timeout () =>
    @containerChannel = @WebSocket.subscribe 'container.:container', container: container.id

    @containerChannel.bind 'log', (chunk) =>
      @logs.push chunk
      @$scope.$apply()
  , 1000
  return
