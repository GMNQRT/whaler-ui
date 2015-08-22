angular.module('whaler.directives').directive 'containerState', [ ()->
  restrict: 'AE'
  scope:
    container: '='

  link : ($scope, $el, $attr, $ctrl) ->
    $scope.$watch (() -> $scope.container?.info?.State), (state) ->
      return $scope.state = "unknow" unless state
      return $scope.state = "dead" if state.Dead
      return $scope.state = "paused" if state.Paused
      return $scope.state = "running" if state.Running
      return $scope.state = "stopped"
    , true

  template: """<span class="text-uppercase label" ng-class="{
      'label-default-outline': state == 'unknow',
      'label-success-outline': state == 'running',
      'label-warning-outline': state == 'paused',
      'label-danger-outline': state == 'dead',
      'label-danger-outline': state == 'stopped'
    }">{{ state }}</span>"""
]