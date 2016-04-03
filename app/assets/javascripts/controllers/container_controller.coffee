angular.module('whaler.controllers').controller 'ContainerController', [
  '$location'
  '$scope'
  '$q'
  '$uibModal'
  'WebSocket'
  'TitleService'
  'ContainerService'
  'SearchService'
  'ContainerFactory'
  ContainerController = (@$location, @$scope, @$q, @$uibModal, @WebSocket, @TitleService, @ContainerService, @SearchService, @ContainerFactory) ->
    @SearchService.setDefaultTpl '/partials/containers/search'

    @checks =
      link: []
      volume: []
      port: []
    @models =
      link: { container: null, alias: "" }
      volume: { name: "", hostDirectory: "" }
      port: { host: "", container: "", protocol: "" }

    @ContainerService.subscribe @$scope, 'update', ($event, container) =>
      @selectedContainer = container
    @ContainerService.subscribe @$scope, 'select', ($event, container) =>
      @unwatch @selectedContainer if @selectedContainer
      @selectedContainer = container
      @TitleService.setTitle 'Container', @selectedContainer.info.Name.substr(1)
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
    hostConfigData = angular.copy @selectedContainer.info.HostConfig

    hostConfigData.Binds.splice index, 1
    @ContainerFactory.binds { id: @selectedContainer.id }, data: hostConfigData

# Mount volume to container
ContainerController::mountVolume = (volume) ->
  if volume.name and volume.hostDirectory
    hostConfigData          = angular.copy @selectedContainer.info.HostConfig
    hostConfigData.Binds || = []

    hostConfigData.Binds.push "#{volume.name}:#{volume.hostDirectory}"
    @ContainerFactory.binds { id: @selectedContainer.id }, data: hostConfigData, () =>
      @models.volume = {}
      @forms.volumes.$setUntouched()

# Bind port to container
ContainerController::bindPort = (portBinding) ->
  if portBinding.container and portBinding.host and portBinding.protocol
    key                            = "#{portBinding.container}/#{portBinding.protocol}"
    hostConfigData                 = angular.copy @selectedContainer.info.HostConfig
    hostConfigData.PortBindings || = {}

    if hostConfigData.PortBindings[key]
      hostConfigData.PortBindings[key].push { HostPort: portBinding.host }
    else
      hostConfigData.PortBindings[key] = [{ HostPort: portBinding.host }]

    @ContainerFactory.binds { id: @selectedContainer.id }, { data: hostConfigData }, () =>
      @models.port = { host: "", container: "", protocol: "" }
      @forms.ports.$setUntouched()

# Bind port to container
ContainerController::unbindPort = (portBinding) ->
  if portBinding.container and portBinding.host and portBinding.container.protocol
    key = "#{portBinding.container.port}/#{portBinding.container.protocol}"

    if @selectedContainer.info.HostConfig.PortBindings and @selectedContainer.info.HostConfig.PortBindings[key]
      index = do () =>
        for binding, index in @selectedContainer.info.HostConfig.PortBindings[key] when binding.HostIp == portBinding.host.ip and binding.HostPort == portBinding.host.port
          return index
        return -1
    if index >= 0
      hostConfigData = angular.copy @selectedContainer.info.HostConfig
      if hostConfigData.PortBindings[key].length == 1
        delete hostConfigData.PortBindings[key]
      else
        hostConfigData.PortBindings[key].splice index, 1
      @ContainerFactory.binds { id: @selectedContainer.id }, { data: hostConfigData }


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

# Search for a container by it's name
ContainerController::searchContainer = (query) ->
  @ContainerService.containers.filter (container) ->
    container.info.Name.substr(1).indexOf(query) >= 0


# Link container with currently selected container
ContainerController::addLinkContainer = (container, category) ->
  if container
    value                   = "#{container.info.Name}:#{@selectedContainer.info.Name}/#{category}@#{container.info.Name.substr(1)}"
    hostConfigData          = angular.copy @selectedContainer.info.HostConfig
    hostConfigData.Links || = []

    if hostConfigData.Links.indexOf(value) < 0
      hostConfigData.Links.push value
      hostConfigData.Links.push "#{container.info.Name}:#{@selectedContainer.info.Name}#{container.info.Name}"
      @ContainerFactory.binds { id: @selectedContainer.id }, { data: hostConfigData }
    @selectedLinkContainers[category] = null
    @searchLinkContainerTexts[category] = null

ContainerController::addLinkCategory = (name) ->
  @newLinkCategories || = []
  @newLinkCategories.push "#{name} #{@newLinkCategories.length + 1}"
