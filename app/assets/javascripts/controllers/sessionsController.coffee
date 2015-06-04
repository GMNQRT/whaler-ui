angular.module('whaler.controllers').controller 'SessionsController', [
  '$location',
  'API',
  SessionsController = (@$location, @API) ->
    @credentials = {}

    return
]


SessionsController::showForm = () ->
  @$location.path '/' if @API.isAuthenticated()

SessionsController::login = (credentials, $event) ->
  $event.preventDefault()
  @API.login(credentials).then () =>
    @$location.path '/'


SessionsController::signout = () ->
  @API.logout()

