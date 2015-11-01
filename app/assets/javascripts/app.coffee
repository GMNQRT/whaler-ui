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
  'ui.bootstrap'
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
      templateUrl: '/partials/dashboard'
      controller: 'HomeController'
      controllerAs: 'ctrl'
      action: 'getInfo'
      title: 'Dashboard'

    $routeProvider.when '/container',
      templateUrl: '/partials/containers/show'
      controller: 'ContainerController'
      controllerAs: 'ctrl'
      action: 'indexAction'
      title: 'Containers'

    $routeProvider.when '/images',
      templateUrl: '/partials/images/show'
      controller: 'ImageController'
      controllerAs: 'ctrl'
      action: 'indexAction'
      title: 'Images'

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


    APIProvider.scheme('http').url('192.168.59.103').port('3000')
    WebSocketProvider.connect('192.168.59.103:3000/websocket')
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
    $rootScope.title = $route.current.title
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
