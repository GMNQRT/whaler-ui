angular.module('whaler.controllers').controller 'HomeController', [
  '$http',
  'API',
  HomeController = (@$http, @API) ->
    @values = []

    return
]


HomeController::getInfo = () ->
  console.log "getInfo"
  @$http.get(@API.baseUrl() + 'home/index.json').success (data, status, headers, config) =>
    @values = data