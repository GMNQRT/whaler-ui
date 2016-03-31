angular.module('whaler.controllers').controller 'Container.ListController', [
  '$scope'
  '$document'
  'WebSocket'
  '$location'
  '$uibModal'
  'ContainerService'
  'SearchService'
  ListController = ($scope, $document, WebSocket, @$location, @$uibModal, @ContainerService, @SearchService) ->
    containersChannel  = WebSocket.subscribe('container') unless containersChannel # Subscribe to containers events
    @containers        = @ContainerService.getContainers(true)

    @containers.$promise.then (containers) => # Retrieve selected container by hash
      hash = @$location.hash()
      for container in containers when container.id == @$location.hash()
        return @ContainerService.select container
      return @ContainerService.select containers[0] if containers.length

    $scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) => # Select active card on history back
      if @ContainerService.selectedContainer?.id != (hash = @$location.hash())
        for container in @containers when container.id == hash
          return @ContainerService.select container
        return @ContainerService.select @containers[0] if @containers.length

    $document.bind 'click', swipeLeftHandler = (() -> if @swipedContainer # hide leavebehinds on outside click
      @swipedContainer = null
      $scope.$apply()
    ).bind(@)

    containersChannel.bind 'event', (data) => # Watch containers events
      @ContainerService.update data.event, data.container
      $scope.$apply()

    $scope.$on '$destroy', () ->
      $document.unbind 'click', swipeLeftHandler
      WebSocket.unsubscribe containersChannel.name
      containersChannel = null

    return
]

ListController::isSwipedLeft = (container) ->
  return container.id is @swipedContainer?.id

ListController::swipeLeft = (container) ->
  @swipedContainer = container

ListController::isActive = (container) ->
  return container.id is @ContainerService.selectedContainer?.id

ListController::select = (container) ->
  @ContainerService.select container
  @$location.hash container.id

ListController::stop = (container) ->
  @ContainerService.stop container

ListController::add = () ->
  @SearchService.showPane '/partials/containers/search'
  angular.element('input', '#searchForm').focus()
  return
