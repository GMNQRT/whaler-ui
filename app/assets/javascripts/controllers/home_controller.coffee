angular.module('whaler.controllers').controller 'HomeController', [
  '$http',
  '$location',
  'API',
  HomeController = (@$http, @$location, @API) ->
    return
]

HomeController::getInfo = () ->
  @$http.get(@API.baseUrl() + 'home/index.json').success (data, status, headers, config) =>
    @values = data

# Display container informations on right pane
HomeController::select = (container) ->
  @$location.path('/container').hash(container.id)
  return
