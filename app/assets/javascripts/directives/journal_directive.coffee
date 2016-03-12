angular.module('whaler.directives').directive 'journal', [ ()->
  restrict: 'E'
  link : ($scope, $el, $attr) ->
    $scope.$watch (() -> $el.childElementCount), () ->
      $el.scrollTop = $el.scrollHeight
  controller: () ->
    return
]
.directive 'journalRow', [ ()->
  require: '^journal'
  restrict: 'E'
  # transclude: true
  scope:
    data: '='
  link : ($scope, $el, $attr) ->
    $scope.formated_data = $scope.data.replace(/^"(.*)\\n"$/, '$1').replace(/\\"/g, '"')

  template: """{{formated_data}}"""
]
