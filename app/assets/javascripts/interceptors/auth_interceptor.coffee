angular.module('whaler.interceptors').factory 'authInterceptor', [ '$q', '$location', '$cookies', ($q, $location, $cookies) ->

  request: (config) ->
    if $cookies.get 'auth_token'
      config.headers ||= {}
      config.headers.token = $cookies.get 'auth_token'

    return config

  responseError: (response) ->
    if response.status == 401
      $location.path '/login'
    $q.reject response

]