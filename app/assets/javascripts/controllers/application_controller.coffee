angular.module('whaler.controllers').controller 'ApplicationController', [
  'SearchService',
  'API',
  ApplicationController = (@SearchService, @API) ->
    @isCollapsed = false
    @search = { hasFocus: false }
    return
]

ApplicationController::getUser = () ->
  @user = @API.getUser()

ApplicationController::toggleNav = () ->
  @isCollapsed = !@isCollapsed

ApplicationController::setSearchFocus = (focus) ->
  @SearchService.showPane() if focus
  @search.hasFocus = focus
