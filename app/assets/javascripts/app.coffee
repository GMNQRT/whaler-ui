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
  ($routeProvider, $locationProvider, $resourceProvider, $httpProvider, APIProvider) ->
    $routeProvider.when '/',
      templateUrl: '/home'
      controller: 'HomeController'
      controllerAs: 'ctrl'
      action: 'getInfo'

    $routeProvider.when '/images',
      templateUrl: '/images'
      controller: 'ImageController'
      controllerAs: 'ctrl'
      action: 'helloWorld'

    $routeProvider.when '/container',
      templateUrl: '/container'
      controller: 'ContainerController'
      controllerAs: 'ctrl'

    $routeProvider.when '/container/:id',
      templateUrl: '/container/:id'
      controller: 'ContainerController'
      controllerAs: 'ctrl'

    $routeProvider.when '/login',
      templateUrl: '/users/sign_in'
      controller: 'SessionsController'
      controllerAs: 'ctrl'

    $routeProvider.when '/signout',
      templateUrl: '/users/sign_in'
      controller: 'SessionsController'
      controllerAs: 'ctrl'
      action: 'signout'

    $routeProvider.otherwise '/'


    APIProvider.scheme('http').url('localhost').port('3000')
    $resourceProvider.defaults.stripTrailingSlashes = true
    $locationProvider.html5Mode(false).hashPrefix('!')
    return
])
.run(['$rootScope', '$route', '$location', ($rootScope, $route, $location) ->
  $location.pushState = (url, params) ->
    angular.extend $route.current.pathParams, params
    $location.path(url);

  $rootScope.$on '$routeChangeSuccess', (ev, data) ->
    $rootScope.controller = data.controller.toLowerCase().replace(/controller/, 'Ctrl') if data.controller?

  $rootScope.$on '$viewContentLoaded', (event) ->
    if $route.current.controllerAs and $route.current.action
      if $route.current.scope[$route.current.controllerAs][$route.current.action]
        $route.current.scope[$route.current.controllerAs][$route.current.action]()
      else
        throw "Undefined action '#{$route.current.action}'' on controller '#{$route.current.controllerAs}'"
])

angular.module 'whaler.filters', []
angular.module 'whaler.services', []
angular.module 'whaler.directives', []
angular.module 'whaler.controllers', []
angular.module 'whaler.factories', []
angular.module 'whaler.provider', []
angular.module 'whaler.interceptors', []
