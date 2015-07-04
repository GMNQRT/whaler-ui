angular.module('whaler.controllers').controller 'ApplicationController', [
  ApplicationController = () ->
    @isCollapsed = false
    return
]

ApplicationController::collapseNav = () ->
  @isCollapsed = !@isCollapsed