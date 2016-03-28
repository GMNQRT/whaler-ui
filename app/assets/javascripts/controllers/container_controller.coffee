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
      volume: { name: "", hostDirectory: "" }
      port: { host: "", container: "", protocol: "" }

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

# Unmount volume to container
ContainerController::unmountVolume = (volume)->
  index = @selectedContainer.info.HostConfig.Binds.indexOf(volume)
  if index >= 0
    (bindsCpy = @selectedContainer.info.HostConfig.Binds.slice(0)).splice index, 1
    @ContainerFactory.binds @selectedContainer, data: { Binds: bindsCpy }

# Mount volume to container
ContainerController::mountVolume = (volume) ->
  if volume.name and volume.hostDirectory
    binding = { Binds: ["#{volume.name}:#{volume.hostDirectory}"].concat(@selectedContainer.info.HostConfig.Binds || []) }
    @ContainerFactory.binds @selectedContainer, data: binding, () =>
      @models.volume = {}
      @forms.volumes.$setUntouched()

# Bind port to container
ContainerController::bindPort = (port) ->
  if port.container and port.host and port.protocol
    key = "#{port.container}/#{port.protocol}"

    if @selectedContainer.info.HostConfig.PortBindings is null
      binding = PortBindings: { "#{key}": [{ HostPort: port.host }] }
    else
      binding = PortBindings:  angular.copy @selectedContainer.info.HostConfig.PortBindings

      if binding.PortBindings[key]
        binding.PortBindings[key].push { HostPort: port.host }
      else
        binding.PortBindings[key] = [{ HostPort: port.host }]

    @ContainerFactory.binds @selectedContainer, data: binding, () =>
      @models.port = { host: "", container: "", protocol: "" }
      @forms.ports.$setUntouched()
