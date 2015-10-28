angular.module('whaler.controllers').controller 'ApplicationController', [
  'API',
  'ContainerService'
  ApplicationController = (@API, @ContainerService) ->
    # @ContainerService.ctrl = @
    # @AsideService.view = '/partials/containers'

    @isCollapsed = false
    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed
