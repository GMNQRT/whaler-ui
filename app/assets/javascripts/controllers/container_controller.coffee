angular.module('whaler.controllers').controller 'ContainerController', [
  '$location'
  '$scope'
  '$q'
  '$uibModal'
  'API'
  'WebSocket'
  'ContainerService'
  ContainerController = (@$location, @$scope, @$q, @$uibModal, @API, @WebSocket, @ContainerService) ->
    @logs = new Array()
    return
]

ContainerController::indexAction = () ->
  prevHash = @$location.hash()

  @selectByHash().then @select.bind(@) if @$location.hash()

  @$scope.$on '$destroy', @unwatch
  @$scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) => # Select active card on history back
    @selectByHash().then @select.bind(@) if @$location.hash() != @prevContainer?.id


# Select container by current hash in URL
ContainerController::selectByHash = () ->
  deferred = @$q.defer()
  @ContainerService.containers.$promise.then (containers) =>
    for container in containers when container.id == @$location.hash()
      @ContainerService.select container
      return deferred.resolve container
  , deferred.reject

  return deferred.promise

# Unbind from container channel
ContainerController::unwatch = () ->
  @WebSocket.unsubscribe(@containerChannel.name) if @containerChannel
  @prevContainer = @containerChannel = null


# Display container informations on right pane
ContainerController::select = (container) ->
  @unwatch() if @prevContainer || !container
  return unless container

  @logs             = new Array()
  @containerChannel = @WebSocket.subscribe("container.:container", container: container.info.Name.substr(1)) # Watch containers logs
  @prevContainer    = container

  @$location.hash(container.id)
  @containerChannel.bind 'log', (data) =>
    @logs.push(data.message)
    @$scope.$apply()

ContainerController::add = () ->
  @$uibModal.open
    controller: 'Container.AddModalController as ctrl'
    templateUrl: '/partials/containers/new'
    size: 'lg'

  return
