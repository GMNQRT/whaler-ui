angular.module('whaler.controllers').controller 'SessionsController', [
  '$location',
  'API',
  SessionsController = (@$location, @API) ->
    @credentials = {}
    @loginForm   = {}

    return
]


SessionsController::showForm = () ->
  @$location.path '/' if @API.isAuthenticated()

SessionsController::login = (credentials, $event) ->
  $event.preventDefault()
  delete @loginForm.$error.credentials
  if @loginForm.$valid
    @API.login(credentials)
      .then () =>
        @$location.path '/'
      .catch () =>
        @loginForm.$error.credentials = true


SessionsController::signout = () ->
  @API.logout()
