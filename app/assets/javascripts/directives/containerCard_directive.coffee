angular.module('whaler.directives').directive 'containerCard', [ '$compile', '$window', '$filter', ($compile, $window, $filter)->
  # Refence to active leave-behind element
  oldLeaveBehind = null

  # Hide leave-behind on click-out
  $window.addEventListener 'click', () -> if oldLeaveBehind
    oldLeaveBehind.removeClass 'show'
    oldLeaveBehind = null

  restrict: 'AE'
  priority: 1500
  scope:
    ngModel: '='
    start: "&"
    stop: "&"
    pause: "&"
    restart: "&"
    remove: "&"
    more: "&"
    onSelect: "&"
  controller : ($scope) ->
  compile: ($el) ->
    $el.attr 'ng-class', "{
      'container-active': ngModel.active,
      'container-default': state == 'unknow',
      'container-success': state == 'running',
      'container-warning': state == 'paused',
      'container-danger': state == 'dead' || state == 'stopped'
    }"

    return ($scope, $el, $attr, $ctrl) ->
      $scope.$watch (() -> $scope.ngModel?.info?.State), (state) ->
        return $scope.state = "unknow" unless state
        return $scope.state = "dead" if state.Dead
        return $scope.state = "paused" if state.Paused
        return $scope.state = "running" if state.Running
        return $scope.state = "stopped"
      , true

      # $scope.time = () ->
      #   now = new Date()
      #   cur = new Date($scope.ngModel.info.Created)
      #
      #   return "#{diff}y" if (diff = now.getYear() - cur.getYear()) > 0
      #   return "#{diff}m" if (diff = now.getMonth() - cur.getMonth()) > 0
      #   return "#{diff}d" if (diff = now.getDay() - cur.getDay()) > 0
      #   return "#{diff}h" if (diff = now.getHours() - cur.getHours()) > 0
      #
      #   diff = now.getMinutes() - cur.getMinutes()
      #   return "#{diff}min"

      $scope.showOption = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        oldLeaveBehind.removeClass 'show' if oldLeaveBehind
        oldLeaveBehind = $el.find('.leave-behinds').addClass 'show'
        return

      $el.append """
        <aside class="leave-behinds btn-group" role="group">
          <a class="btn btn-danger col-xs-3" ng-show="state != 'running' && state != 'paused'" ng-click="remove()">Remove</a>
          <a class="btn btn-success col-xs-3" ng-show="state != 'running'" ng-click="start(ngModel)"><i class="fa fa-play"></i></a>
          <a class="btn btn-danger col-xs-3" ng-show="state == 'running' || state == 'paused'" ng-click="stop(ngModel)"><i class="fa fa-stop"></i></a>
          <a class="btn btn-warning col-xs-3" ng-show="state == 'running'" ng-click="pause(ngModel)"><i class="fa fa-pause"></i></a>
          <a class="btn btn-default col-xs-3" ng-show="state == 'running' || state == 'paused'" ng-click="restart(ngModel)"><i class="fa fa-undo"></i></a>
        </aside>
        <div class="container-state col-xs-3">
          <div class="state-icon">{{ngModel.info.Name|limitTo:1:1}}</div>
        </div>
        <div class="container-body col-xs-9" ng-click="onSelect(ngModel)">
          <header>
            <span class="container-time">{{ngModel.info.Created|timeAgo}}</span>
            <h2 class="container-title">{{ngModel.info.Name}}</h2>
            <small>{{ngModel.info.Config.Image}}</small>
          </header>
          <a class="container-toggle-option" ng-click="showOption($event)"><i class="fa fa-ellipsis-h"></i></a>
        </div>"""
      $compile($el, null, 1500)($scope)
]
