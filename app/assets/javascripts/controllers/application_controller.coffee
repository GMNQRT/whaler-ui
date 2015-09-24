angular.module('whaler.controllers').controller 'ApplicationController', [
  'API',
  ApplicationController = (@API) ->
    @isCollapsed = false
    @rightPaneIsShown = false

    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed
