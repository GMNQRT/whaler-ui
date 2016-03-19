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

    @models =
      volume: {}

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


ContainerController::mountVolume = (volume) ->
  if volume.name and volume.hostDirectory
    binding = { Binds: ["#{volume.name}:#{volume.hostDirectory}"].concat(@selectedContainer.info.HostConfig.Binds || []) }
    @ContainerFactory.binds @selectedContainer, data: binding, () =>
      @models.volume = {}
      @forms.volumes.$setUntouched()
