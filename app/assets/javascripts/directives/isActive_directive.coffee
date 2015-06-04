angular.module('whaler.directives').directive 'isActive', [ '$location', ($location) ->
  restrict: 'A'
  link: ($scope, $element, $attr) ->
    $scope.$on "$routeChangeSuccess", (event, current, previous) ->
      if $location.path().split('/')[1].split('?')[0] == $attr.href.split('/')[1]
        angular.element($element).addClass('active')
      else
        angular.element($element).removeClass('active')
]