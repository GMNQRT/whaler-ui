angular.module('whaler.interceptors').factory 'authInterceptor', [ '$q', '$location', '$cookies', ($q, $location, $cookies) ->

  request: (config) ->
    if (user = $cookies.getObject('user')) and user.authentication_token
      config.headers ||= {}
      config.headers.token = user.authentication_token

    return config

  responseError: (response) ->
    if response.status == 401
      $location.path '/login'
      $cookies.remove 'user'
    $q.reject response

]