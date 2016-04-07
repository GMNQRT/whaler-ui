angular.module('whaler.controllers').controller 'Container.NewController', [
  '$mdDialog'
  'SearchService'
  'ImageFactory'
  NewController = (@$mdDialog, @SearchService, @ImageFactory) ->
    @container = {
      exposedPorts: []
      portBindings: []
      binds: []
      name: ""
      command: ""
      tag: ""
      entrypoint: ""
    }
    return
]

# Load image's tags from DockerHub API
NewController::loadTags = () ->
  @image.tags = @ImageFactory.tags image: @image.id unless @image.tags

# Add port to expose list
NewController::exposePort = (container) ->
  container.exposedPorts.push {
    port: ""
    protocol: "tcp"
  }

# Remove port from expose list
NewController::unexposePort = (container, binding) ->
  idx = container.exposedPorts.indexOf binding

  if idx >= 0
    container.exposedPorts.splice idx, 1

# Add port to binding list
NewController::bindPort = (container) ->
  container.portBindings.push {
    container: ""
    host: ""
    protocol: "tcp"
  }

# Remove port from binding list
NewController::unbindPort = (container, port) ->
  idx = container.portBindings.indexOf port

  if idx >= 0
    container.portBindings.splice idx, 1

# Remove all ports from binding list
NewController::unbindAllPorts = (container) ->
  container.portBindings.splice 0

# Add volume to binding list
NewController::mountVolume = (container) ->
  container.binds.push {
    name: ""
    hostDirectory: ""
  }

# Remove volume from binding list
NewController::unmountVolume = (container, volume) ->
  idx = container.binds.indexOf volume

  if idx >= 0
    container.binds.splice idx, 1

# Remove all volumes from binding list
NewController::unmountAllVolumes = (container) ->
  container.binds.splice 0

# Close dialog
NewController::cancel = () ->
  @$mdDialog.hide()

# Create container then close dialog and search pane
NewController::create = (container) ->
  image.$loading = @ImageFactory.run { id: @image.id }, config: container, () =>
    @SearchService.hidePane()
    @$mdDialog.hide()
