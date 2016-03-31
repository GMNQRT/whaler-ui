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

    @checks =
      volume: []
      port: []
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


# Check if at least one checkbox is checked
ContainerController::isIndeterminate = (checkList, itemsList) ->
  return checkList.length != 0 and checkList.length != itemsList?.length

# Check if all checkboxes are checked
ContainerController::isAllChecked = (checkList, itemsList) ->
  return checkList.length == itemsList?.length > 0

# Check if this checkbox is checked
ContainerController::isChecked = (item, checkList) ->
  return checkList.indexOf(item) > -1

# Toggle checkbox state
ContainerController::toggle = (item, checkList) ->
  if (idx = checkList.indexOf(item)) > -1
    checkList.splice idx, 1
  else
    checkList.push item

# Toggle checkboxes states
ContainerController::toggleAll = (checkList, itemsList) ->
  if checkList.length == itemsList?.length
    checkList.splice(0)
  else if itemsList?.length
    checkList.splice(0)
    checkList.push item for item in itemsList
