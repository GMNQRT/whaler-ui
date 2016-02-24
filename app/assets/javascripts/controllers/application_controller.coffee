angular.module('whaler.controllers').controller 'ApplicationController', [
  'SearchService',
  'API',
  ApplicationController = (@SearchService, @API) ->
    @isCollapsed = false
    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed
