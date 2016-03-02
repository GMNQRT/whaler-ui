angular.module('whaler.directives').directive 'clickOut', [
  '$window',
  '$parse',
  ($window, $parse) ->
    restrict: 'A',
    link: ($scope, $element, $attrs) ->
      clickOutHandler = $parse($attrs.clickOut)

      handleClickEvent = (event) ->
        unless $element[0].contains(event.target)
          clickOutHandler $scope, { $event: event }
          $scope.$apply()

      angular.element($window).on 'click', handleClickEvent

      $scope.$on '$destroy', () ->
        angular.element($window).off 'click', handleClickEvent

]
