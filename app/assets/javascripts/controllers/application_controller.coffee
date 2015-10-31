angular.module('whaler.controllers').controller 'ApplicationController', [
  'API',
  'ContainerService'
  ApplicationController = (@API, @ContainerService) ->
    @isCollapsed = false
    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed
