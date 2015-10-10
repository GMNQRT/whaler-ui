# Wrap WebSocketRails in an angular provider
angular.module('whaler.provider').provider 'WebSocket', [ () ->
  dispatcher = {}

  @connect =  (url) =>
    dispatcher = new WebSocketRails(url)
    return @

  @$get = () ->
    dispatcher: dispatcher

    subscribe: (channel_name, data, success_callback, failure_callback) ->
      triggered_channel_name = channel_name.replace /\.?:([^.]+)/g, ""
      subscribed_channel_name = channel_name.replace /:([^.]+)/g, (m, p1, offset, str) -> data[p1] || ""

      dispatcher.subscribe(subscribed_channel_name, () ->
        dispatcher.trigger "#{triggered_channel_name}.subscribe", { data: data }
      , success_callback
      , failure_callback)

    unsubscribe: (channel_name, data) ->
      triggered_channel_name = channel_name.replace /\.?:([^.]+)/g, ""
      subscribed_channel_name = channel_name.replace /:([^.]+)/g, (m, p1, offset, str) -> data[p1] || ""

      dispatcher.trigger "#{triggered_channel_name}.unsubscribe", { data: data }
      dispatcher.unsubscribe subscribed_channel_name

  @
]
