angular.module('whaler.directives').directive 'containerCard', [ ()->
  restrict: 'AE'
  scope:
    ngModel: '='
    start: "&"
    stop: "&"
    pause: "&"
    restart: "&"
    exec: "&"
    remove: "&"
    onSelect: "&"

  controller : ($scope) ->
    $scope.toggleRightPane = () ->
      $scope.onSelect($scope.ngModel)
      return

  template: """
<div class="panel panel-default">
  <div class="panel-header col-xs-3 p-a bg-success">
    <h2 class="panel-title">{{ngModel.info.Config.Image}}</h2>
  </div>
  <div class="panel-body col-xs-9">
    <header>
      <container-state container="ngModel" class="pull-right"></container-state>
      <h2 class="panel-title">{{ngModel.info.Name}}</h2>
    </header>
    <footer class="btn-group" role="group">
      <a class="btn btn-default" ng-show="ngModel.info.State.Running === false || ngModel.info.State.Paused" ng-click="start(ngModel)"><i class="fa fa-play"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running || ngModel.info.State.Paused" ng-click="stop(ngModel)"><i class="fa fa-stop"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running && ngModel.info.State.Paused === false" ng-click="pause(ngModel)"><i class="fa fa-pause"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running || ngModel.info.State.Paused" ng-click="restart(ngModel)"><i class="fa fa-undo"></i></a>
      <a class="btn btn-default" ng-show="ngModel.info.State.Running && ngModel.info.State.Paused === false" ng-click="exec(ngModel)"><i class="fa fa-terminal"></i></a>
      <div class="btn-group pull-right" role="group">
        <a class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="fa fa-ellipsis-v"></i></a>
        <ul class="dropdown-menu">
          <li><a href="#">remove</a></li>
          <li><a href="#" ng-click="toggleRightPane()">More info</a></li>
        </ul>
      </div>
    </footer>
  </div>
</div>"""
]
