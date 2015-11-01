angular.module('whaler.directives').directive 'imageList', [
  'ImageService'
  (ImageService) ->
    restrict: 'AE'
    transclude : true
    controller: ($scope) ->
      $scope.$images = ImageService.images
      ImageService.bindTo $scope
    compile: ($el, $attrs) ->
      return ($scope, $wrapper, $wrapperAttrs, $ctrl, $transclude) ->
        $transclude $scope, (clone) ->
          $wrapper.append clone
]


angular.module('whaler.directives').directive 'imageCard', [
  '$compile'
  '$window'
  '$timeout'
  'ImageService'
  ($compile, $window, $timeout, ImageService)->
    # Refence to active leave-behind element
    oldLeaveBehind = null

    # Hide leave-behind on click-out
    $window.addEventListener 'click', () -> if oldLeaveBehind
      oldLeaveBehind.removeClass 'show'
      oldLeaveBehind = null

    restrict: 'AE'
    priority: 1500
    require: '^?imageList'
    scope:
      ngModel: '='
      onStart: "&"
      onRemove: "&"
      onSelect: "&"
    controller: ($scope) ->
      $scope.start = (image) ->
        ImageService.start(image).$promise.then () ->
          $scope.onStart(image) if $scope.onStart

      $scope.remove = (image) ->
        ImageService.remove(image).$promise.then () ->
          $scope.onRemove(image) if $scope.onRemove

      $scope.select = (image) ->
        if ImageService.images[ImageService.selectedImage]
          ImageService.images[ImageService.selectedImage].active = false
        $scope.ngModel.active = true
        ImageService.select(image)
        $scope.onSelect(image) if $scope.onSelect

    compile: ($el) ->
      $el.attr 'ng-class', "{
        'image-active': ngModel.active,
      }"
      return ($scope, $el, $attr, $ctrl) ->
        $scope.showOption = ($event) ->
          $event.preventDefault()
          $event.stopPropagation()
          oldLeaveBehind.removeClass 'show' if oldLeaveBehind
          oldLeaveBehind = $el.find('.leave-behinds').addClass 'show'
          return

        $scope.$watch (() -> $scope.ngModel?.tilt), (tilt) ->
          $timeout (() -> $scope.ngModel?.tilt = false), 1000 if tilt == true
          $el.find('.state-icon').toggleClass 'tilt', tilt == true

        $el.append """
          <aside class="leave-behinds btn-group" role="group">
            <a class="btn btn-danger col-xs-3" ng-click="remove(ngModel)">Remove</a>
            <a class="btn btn-success col-xs-3" ng-click="start(ngModel)"><i class="fa fa-play"></i></a>
          </aside>
          <div class="image-state col-xs-3">
            <div class="state-icon">{{ngModel.info.RepoTags[0]|limitTo:1:0}}</div>
          </div>
          <div class="image-body col-xs-9" ng-click="select(ngModel)">
            <header>
              <h2 class="image-title">{{ngModel.info.RepoTags[0]}}</h2>
            </header>
            <aside>
              <span class="image-time">{{(ngModel.info.Created * 1000)|timeAgo}}</span>
              <a class="image-toggle-option" ng-click="showOption($event)"><i class="fa fa-ellipsis-h"></i></a>
            </aside>
          </div>"""
        $compile($el, null, 1500)($scope)
]
