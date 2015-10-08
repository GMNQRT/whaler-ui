angular.module('whaler.directives').directive 'journal', [ ()->
  restrict: 'E'
  transclude: true
  controller: () ->
  link : ($scope, $el, $attr, $ctrl) ->
    rows = $el.find('ng-transclude')[0]
    $scope.$watch (() -> rows.childElementCount), () ->
      $el[0].scrollTop = $el[0].scrollHeight

  template: """<ng-transclude></ng-transclude>"""
]
.directive 'log', [ ()->
  require: '^journal'
  restrict: 'E'
  transclude: true
  scope:
    data: '='
  link : ($scope, $el, $attr) ->
    $scope.formated_data = $scope.data.replace(/^"(.*)\\n"$/, '$1').replace(/\\"/g, '"')

  template: """{{formated_data}}"""
]
