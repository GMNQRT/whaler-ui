# Some helpers to build API's root url and resources' urls
angular.module('whaler.provider').provider 'API', [ '$httpProvider', ($httpProvider) ->
  config =
    scheme: "http"
    url: "localhost"
    port: "3000"

  $httpProvider.interceptors.push 'authInterceptor'

  @scheme =  (scheme) =>
    config.scheme = scheme
    return @

  @url = (url) =>
    config.url = url
    return @

  @port = (port) =>
    config.port = port
    return @

  @$get = [ '$http', '$cookies', ($http, $cookies) ->
    baseUrl: () ->
      "#{config.scheme}://#{config.url}:#{config.port}/"

    generateResourceUrl: (path) ->
      "#{config.scheme}://#{config.url}:#{config.port}/#{path}.:format"

    login: (credentials) ->
      $http.post "#{config.scheme}://#{config.url}:#{config.port}/users/sign_in.json", credentials
      .then (response) ->
        $cookies.putObject 'user', response.data.user
        return response.data


    logout: (redirection) ->
      $http.delete("#{config.scheme}://#{config.url}:#{config.port}/users/sign_out.json")
      .then () ->
        $cookies.remove 'user'
        $location.path redirection if redirection

    isAuthenticated: () ->
      return if (user = $cookies.getObject('user')) and user.authentication_token then true else false

    getUser: () ->
      return $cookies.getObject('user')
  ]

  @
]