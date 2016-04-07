angular.module('whaler.controllers').controller 'RegistrationsController', [
  '$http',
  'RegistrationsFactory',
  '$location',
  'API',
  RegistrationsController = (@$http, @RegistrationsFactory, @$location, @API) ->
    @users = @RegistrationsFactory.query (users) =>
      @selectedUser = users[0] if users[0]
    return
]

RegistrationsController::getUser = (user) ->
  @selectedUser = user

RegistrationsController::editUser = (user) ->
  user.$update()

RegistrationsController::deleteUser = (user) ->
  idx = @users.indexOf user

  if idx >= 0
    user.$delete () =>
      @users.splice idx, 1
      @selectedUser = @users[idx - 1] if @users[idx - 1]

RegistrationsController::showNewUserForm = () ->
  @selectedUser = {
    first_name: ""
    last_name: ""
    role: ""
    email: ""
    password: ""
    password_confirmation: ""
  }

RegistrationsController::createUser = (user) ->
  newUser = new @RegistrationsFactory(user)
  newUser.$save (savedUser) =>
    @selectedUser = savedUser
    @users.push savedUser
