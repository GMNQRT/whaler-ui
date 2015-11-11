# Wrap WebSocketRails in an angular provider
angular.module('whaler.provider').provider 'WebSocket', [ () ->
  config = {}

  @scheme = (scheme) =>
    config.scheme = scheme
    return @

  @url = (url) =>
    config.url = url
    return @

  @port = (port) =>
    config.port = port
    return @

  @connect = () =>
    @$get.dispatcher = new WebSocketRails("#{config.url}:#{config.port}/websocket")
    return @

  @$get = () =>
    $provider: @

    dispatcher: {}

    subscribe: (channel_name, data, success_callback, failure_callback) =>
      subscribed_channel_name = channel_name.replace /:([^.]+)/g, (m, p1, offset, str) -> data[p1] || ""

      @$get.dispatcher.subscribe subscribed_channel_name, success_callback, failure_callback

    unsubscribe: (channel_name, data) =>
      subscribed_channel_name = channel_name.replace /:([^.]+)/g, (m, p1, offset, str) -> data[p1] || ""

      @$get.dispatcher.unsubscribe subscribed_channel_name

  @
]
