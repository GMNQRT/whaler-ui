angular.module('whaler.directives').directive 'containerCard', [ '$compile', ($compile)->
  restrict: 'AE'
  priority: 1500
  scope:
    ngModel: '='
    start: "&"
    stop: "&"
    pause: "&"
    restart: "&"
    exec: "&"
    remove: "&"
    more: "&"
    onSelect: "&"

  controller : ($scope) ->
  link : ($scope, $el, $attr, $ctrl) ->
    $scope.$watch (() -> $scope.ngModel?.info?.State), (state) ->
      return $scope.state = "unknow" unless state
      return $scope.state = "dead" if state.Dead
      return $scope.state = "paused" if state.Paused
      return $scope.state = "running" if state.Running
      return $scope.state = "stopped"
    , true

    $el.attr 'ng-class', "{
      'container-active': ngModel.active,
      'container-default': state == 'unknow',
      'container-success': state == 'running',
      'container-warning': state == 'paused',
      'container-danger': state == 'dead' || state == 'stopped'
    }"

    $compile($el, null, 1500)($scope)

  template: """
  <div class="container-state col-xs-3">
    <div class="state-icon">{{ngModel.info.Name|limitTo:1:1}}</div>
  </div>
  <div class="container-body col-xs-9" ng-click="onSelect(ngModel)">
    <header>
      <span class="container-time">12h</span>
      <h2 class="container-title">{{ngModel.info.Name}}</h2>
      <small>{{ngModel.info.Config.Image}}</small>
    </header>
    <a class="container-toggle-option"><i class="fa fa-ellipsis-h"></i></a>

    <!--footer class="btn-group" role="group">
      <a class="btn btn-default" ng-show="ngModel.info.State.Running === false || ngModel.info.State.Paused" ng-click="start(ngModel)"><i class="fa fa-play"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running && ngModel.info.State.Paused === false" ng-click="stop(ngModel)"><i class="fa fa-stop"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running && ngModel.info.State.Paused === false" ng-click="pause(ngModel)"><i class="fa fa-pause"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running || ngModel.info.State.Paused" ng-click="restart(ngModel)"><i class="fa fa-undo"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running && ngModel.info.State.Paused === false" ng-click="exec(ngModel)"><i class="fa fa-terminal"></i></a>
      <div class="btn-group pull-right" role="group">
        <a class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="fa fa-ellipsis-v"></i></a>
        <ul class="dropdown-menu">
          <li><a href="#" ng-click="remove()">Remove</a></li>
          <li><a href="#" ng-click="more(ngModel)">More info</a></li>
        </ul>
      </div>
    </footer-->
  </div>
"""
]
