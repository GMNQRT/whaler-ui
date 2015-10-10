angular.module('whaler', [
  'ngRoute'
  'ngResource'
  'ngCookies'
  'templates'
  'whaler.filters'
  'whaler.provider'
  'whaler.services'
  'whaler.factories'
  'whaler.directives'
  'whaler.controllers'
  'whaler.interceptors'
])
.config([
  '$routeProvider'
  '$locationProvider'
  '$resourceProvider'
  '$httpProvider'
  'APIProvider'
  'WebSocketProvider'
  ($routeProvider, $locationProvider, $resourceProvider, $httpProvider, APIProvider, WebSocketProvider) ->
    $routeProvider.when '/',
      templateUrl: '/partials/home'
      controller: 'HomeController'
      controllerAs: 'ctrl'
      action: 'getInfo'

    $routeProvider.when '/images',
      templateUrl: '/partials/images'
      controller: 'ImageController'
      controllerAs: 'ctrl'

    $routeProvider.when '/container',
      templateUrl: '/partials/containers'
      controller: 'ContainerController'
      controllerAs: 'ctrl'
      action: 'indexAction'

    $routeProvider.when '/container/:id',
      templateUrl: '/partials/containers/show'
      controller: 'ContainerController'
      controllerAs: 'ctrl'
      action: 'showAction'

    $routeProvider.when '/login',
      templateUrl: '/partials/users/sign_in'
      controller: 'SessionsController'
      controllerAs: 'ctrl'
      action: 'showForm'

    $routeProvider.when '/signout',
      templateUrl: '/partials/users/sign_in'
      controller: 'SessionsController'
      controllerAs: 'ctrl'
      action: 'signout'

    $routeProvider.otherwise '/'


    APIProvider.scheme('http').url('192.168.59.104').port('3000')
    WebSocketProvider.connect('192.168.59.104:3000/websocket')
    $resourceProvider.defaults.stripTrailingSlashes = true
    $locationProvider.html5Mode(true).hashPrefix('!')
    return
])
.run(['$rootScope', '$route', '$location', ($rootScope, $route, $location) ->
  $location.pushState = (url, params) ->
    angular.extend $route.current.pathParams, params
    $location.path(url)

  $rootScope.$on '$routeChangeSuccess', (ev, data) ->
    $rootScope.controller = data.controller.toLowerCase().replace(/controller/, 'Ctrl') if data.controller?

  $rootScope.$on '$viewContentLoaded', (event) ->
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
