angular.module('whaler.controllers').controller 'navigationController', [
  '$location',
  'API',
  NavigationController = (@$location, @API) ->
    @credentials = {}

    return
]


NavigationController::showForm = () ->
  @$location.path '/' if @API.isAuthenticated()

NavigationController::login = (credentials, $event) ->
  $event.preventDefault()
  @API.login(credentials).then () =>
    @$location.path '/'


NavigationController::signout = () ->
  @API.logout()

