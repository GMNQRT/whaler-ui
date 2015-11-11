angular.module('whaler.controllers').controller 'ApiConfigsController', [
  '$http'
  '$location'
  'API'
  'WebSocket'
  ApiConfigsController = (@$http, @$location, @API, @WebSocket) ->
    @config =
      scheme: @$location.protocol()
      host: @$location.host()
      port: '3000'
    return
]

ApiConfigsController::send = (config, $event) ->
  $event.preventDefault()
  @$http.post('api_config', config).then (response) =>
    @API.$provider.scheme(response.data.scheme).url(response.data.host).port(response.data.port)
    @WebSocket.$provider.url(response.data.host).port(response.data.port).connect()
    @$location.path '/'
