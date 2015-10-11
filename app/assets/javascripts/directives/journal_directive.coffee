angular.module('whaler.directives').directive 'journal', [ ()->
  restrict: 'E'
  transclude: true
  controller: () ->
  link : ($scope, $el, $attr, $ctrl, $transclude) ->
    $transclude $scope, (clone) ->
      $el.append clone
]
.directive 'journalBody', [ ()->
  require: '^journal'
  restrict: 'E'
  transclude: true
  link : ($scope, $el, $attr, $ctrl, $transclude) ->
    $el.append $transclude()
    $scope.$watch (() -> $el.childElementCount), () ->
      $el.scrollTop = $el.scrollHeight
]
.directive 'journalRow', [ ()->
  require: ['^journalBody', '^journal']
  restrict: 'E'
  transclude: true
  scope:
    data: '='
  link : ($scope, $el, $attr) ->
    $scope.formated_data = $scope.data.replace(/^"(.*)\\n"$/, '$1').replace(/\\"/g, '"')

  template: """{{formated_data}}"""
]
