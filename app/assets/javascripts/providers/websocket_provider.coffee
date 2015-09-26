# Wrap WebSocketRails in an angular provider
angular.module('whaler.provider').provider 'WebSocket', [ () ->
  dispatcher = {}

  @connect =  (url) =>
    dispatcher = new WebSocketRails(url)
    return @

  @$get = () -> dispatcher

  @
]
