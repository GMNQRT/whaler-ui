angular.module('whaler.controllers').controller 'ContainerController', [
  '$location'
  '$scope'
  '$q'
  '$uibModal'
  'WebSocket'
  'ContainerService'
  'SearchService'
  'ContainerFactory'
  ContainerController = (@$location, @$scope, @$q, @$uibModal, @WebSocket, @ContainerService, @SearchService, @ContainerFactory) ->
    @SearchService.setDefaultTpl '/partials/containers/search'
    @ContainerService.subscribe @$scope, 'update', ($event, container) =>
      @selectedContainer = container
    @ContainerService.subscribe @$scope, 'select', ($event, container) =>
      @unwatch @selectedContainer if @selectedContainer
      @selectedContainer = container
      @watch container


    @$scope.$on '$destroy', () =>
      @unwatch @selectedContainer if @selectedContainer
    return
]

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


ContainerController::mountVolume = (newVolume) ->
  if @selectedContainer.info.HostConfig.Binds
    @selectedContainer.info.HostConfig.Binds.push "#{newVolume.name}:#{newVolume.hostDirectory}"
  else
    @selectedContainer.info.HostConfig.Binds = ["#{newVolume.name}:#{newVolume.hostDirectory}"]
  @ContainerFactory.update { id: @selectedContainer.id }, @selectedContainer
  # @ContainerFactory.update { id: @selectedContainer.id }, Binds: ["#{newVolume.name}:#{newVolume.hostDirectory}"]
