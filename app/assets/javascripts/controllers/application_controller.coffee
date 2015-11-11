angular.module('whaler.controllers').controller 'ApplicationController', [
  'API',
  ApplicationController = (@API) ->
    @isCollapsed = false
    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed
