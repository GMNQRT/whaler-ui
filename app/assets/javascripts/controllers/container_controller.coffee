angular.module('whaler.controllers').controller 'ContainerController', [
  '$location'
  '$scope'
  '$q'
  '$uibModal'
  'WebSocket'
  'ContainerService'
  ContainerController = (@$location, @$scope, @$q, @$uibModal, @WebSocket, @ContainerService) ->
    @ContainerService.subscribe @$scope, 'select', ($event, container) =>
      @unwatch @selectedContainer if @selectedContainer
      @selectedContainer = container
      @watch container

    @$scope.$on '$destroy', () =>
      @unwatch @selectedContainer if @selectedContainer
    return
]

ContainerController::indexAction = () ->
  # @containers = @ContainerService.getContainers()
  # prevHash    = @$location.hash()
  #
  # @ContainerService.bindTo @$scope
  # @selectByHash() if @$location.hash()
  #
  # @$scope.$on '$destroy', @unwatch
  # @$scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) => # Select active card on history back
  #   @selectByHash() if @$location.hash() != @selectedContainer?.id


# # Select container by current hash in URL
# ContainerController::selectByHash = () ->
#   deferred = @$q.defer()
#   @containers.$promise.then (containers) =>
#     for container in containers when container.id == @$location.hash()
#       @select container
#       return deferred.resolve container
#   , deferred.reject
#
#   return deferred.promise
#
#
#

# Bind to container channel
ContainerController::watch = (container) ->
  @logs              = new Array()
  @containerChannel  = @WebSocket.subscribe("container.:container", container: container.info.Name.substr(1)) # Watch containers logs

  @containerChannel.bind 'log', (data) =>
    @logs.push(data.message)
    @$scope.$apply()

# Unbind to container channel
ContainerController::unwatch = (container) ->
  @WebSocket.unsubscribe("container.:container", container: container.info.Name.substr(1)) if @containerChannel
