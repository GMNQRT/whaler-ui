angular.module('whaler', [
  'ngRoute'
  'ngResource'
  'ngCookies'
  'ngSanitize'
  'ngMessages'
  'ngMaterial'
  'templates'
  'whaler.filters'
  'whaler.provider'
  'whaler.services'
  'whaler.factories'
  'whaler.directives'
  'whaler.controllers'
  'whaler.interceptors'
  'ui.bootstrap'
])
.config([
  '$routeProvider'
  '$locationProvider'
  '$resourceProvider'
  '$httpProvider'
  '$mdIconProvider'
  '$mdThemingProvider'
  'APIProvider'
  'WebSocketProvider'
  'RouterProvider'
  ($routeProvider, $locationProvider, $resourceProvider, $httpProvider, $mdIconProvider, $mdThemingProvider, APIProvider, WebSocketProvider, RouterProvider) ->
    RouterProvider.when '/',
      alias:       'root'
      title:       'Dashboard'
      templateUrl: '/partials/dashboard'
      controller:  'HomeController'
      action:      'getInfo'

    .when '/hello',
      alias:       'configure'
      title:       'Configuration'
      templateUrl: '/api_config/new'
      controller:  'ApiConfigsController'
      , false

    .when '/container/:id?',
      alias:          'containers'
      title:          'Containers'
      templateUrl:    '/partials/containers/show'
      controller:     'ContainerController'
      # action:         'indexAction'
      reloadOnSearch: false

    .when '/images',
      alias:       'images'
      title:       'Images'
      templateUrl: '/partials/images/show'
      controller:  'ImageController'
      action:      'indexAction'

    .when '/login',
      alias:       'login'
      templateUrl: '/partials/users/sign_in'
      controller:  'SessionsController'
      action:      'showForm'
      , false

    .when '/signout',
      alias:       'signout'
      controller:  'SessionsController'
      action:      'signout'
      templateUrl: '/partials/users/sign_in'

    .when '/users',
      alias:       'users'
      controller:  'RegistrationsController'
      templateUrl: '/partials/users'

    $routeProvider.otherwise '/'

    $resourceProvider.defaults.stripTrailingSlashes = true
    $locationProvider.html5Mode(true).hashPrefix('!')
    $mdIconProvider.fontSet 'fa', 'fontawesome'
    $mdThemingProvider.theme('default').primaryPalette('blue')

    $httpProvider.defaults.headers.patch =
      'Content-Type': 'application/json;charset=utf-8'
    return
])
.run(['$rootScope', '$route', '$location', '$http', 'API', 'WebSocket', 'Router', ($rootScope, $route, $location, $http, API, WebSocket, Router) ->

  $http.get('/api_config.json').then (response) ->
    API.$provider.scheme(response.data.scheme).url(response.data.host).port(response.data.port)
    WebSocket.$provider.url(response.data.host).port(response.data.port).connect()
  , () ->
    Router.redirectTo 'configure'

  $location.pushState = (url, params) ->
    angular.extend $route.current.pathParams, params
    $location.path(url)

  $rootScope.$on '$routeChangeSuccess', (ev, data) ->
    $rootScope.controller = data.controller.toLowerCase().replace(/controller/, 'Ctrl') if data.controller?

  $rootScope.$on '$viewContentLoaded', (event) ->
    # $rootScope.title = $route.current.title
    if $route.current.controllerAs and $route.current.action
      if $route.current.scope[$route.current.controllerAs][$route.current.action]
        $route.current.scope[$route.current.controllerAs][$route.current.action]()
      else
        throw new Error("Undefined action '#{$route.current.action}'' on controller '#{$route.current.controllerAs}'")
])

angular.module 'whaler.filters', []
angular.module 'whaler.services', []
angular.module 'whaler.directives', []
angular.module 'whaler.controllers', []
angular.module 'whaler.factories', []
angular.module 'whaler.provider', []
angular.module 'whaler.interceptors', []
