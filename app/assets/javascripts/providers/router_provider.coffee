# Wrap original $routeProvider
angular.module('whaler.provider').provider 'Router', [
  '$routeProvider'
  ($routeProvider) ->
    mapping = {}

    @when = (path, route, require_login = true) =>
      if route.alias
        mapping[route.alias] = route
        mapping[route.alias].path = path

      route.controllerAs ||= "ctrl"

      if require_login
        route.resolve = angular.merge route.resolve || {}, is_logged: [
          'API', 'Router', (API, Router) -> Router.redirectTo('login') if !API.isAuthenticated()
        ]
      $routeProvider.when path, route

      return @

    @$get = ['$location', ($location) ->
      get: (alias) ->
        return mapping[alias]

      path: (alias) ->
        return mapping[alias]?.path

      redirectTo: (alias) ->
        return $location.path mapping[alias]?.path
    ]

    return @
]
