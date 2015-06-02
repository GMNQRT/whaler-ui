# Some helpers to build API's root url and resources' urls
angular.module('whaler.provider').provider 'API', [() ->
  config =
    scheme: "http"
    url: "localhost"
    port: "3000"

  @scheme =  (scheme) =>
    config.scheme = scheme
    return @

  @url = (url) =>
    config.url = url
    return @

  @port = (port) =>
    config.port = port
    return @

  @baseUrl = () ->
    "#{config.scheme}://#{config.url}:#{config.port}/"

  @$get = [ () =>
    baseUrl: () =>
      @baseUrl

    generateResourceUrl: (path) ->
      "#{config.scheme}://#{config.url}:#{config.port}/#{path}.:format"
  ]

  @
]