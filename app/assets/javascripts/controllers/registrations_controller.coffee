angular.module('whaler.controllers').controller 'RegistrationsController', [
  '$http',
  'RegistrationsFactory',
  '$location',
  'API',
  RegistrationsController = (@$http, @RegistrationsFactory, @$location, @API) ->
    @RegistrationsFactory.query (data) =>
      @users = data
    return
]

RegistrationsController::getUser = (user) ->
  @selectedRegistrations = @RegistrationsFactory.get { id: user.id }
  return @selectedRegistrations