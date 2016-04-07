angular.module('whaler.controllers').controller 'RegistrationsController', [
  '$http',
  'RegistrationsFactory',
  '$location',
  'API',
  RegistrationsController = (@$http, @RegistrationsFactory, @$location, @API) ->
    @RegistrationsFactory.query (data) =>
      @users = data
    @notice = null
    @newUserForm = false
    return
]

RegistrationsController::getUser = (user) ->
  @selectedRegistrations = @RegistrationsFactory.get { id: user.id }
  @newUserForm = false
  return @selectedRegistrations

RegistrationsController::editUser = (user) ->
  @notice = @RegistrationsFactory.updateUser id: user.id,
  user: {
    first_name: user.first_name,
    last_name: user.last_name,
    role: user.role,
    email: user.email,
    updated_at: new Date(),
    password: user.password,
    password_confirmation: user.password_confirmation
  }
  this.getUser(user)

RegistrationsController::deleteUser = (user) ->
  @notice = @RegistrationsFactory.delete { id: user.id }
  @selectedRegistrations = null
  @RegistrationsFactory.query (data) =>
    @users = data

RegistrationsController::showNewUserForm = () ->
  @newUserForm = true

RegistrationsController::createUser = (user) ->
  @notice = @RegistrationsFactory.save user: {
    first_name: user.first_name,
    last_name: user.last_name,
    role: user.role,
    email: user.email,
    created_at: new Date(),
    updated_at: new Date(),
    password: user.password,
    password_confirmation: user.password_confirmation
  }
  @newUserForm = false
  @RegistrationsFactory.query (data) =>
    @users = data
  this.getUser(user)

