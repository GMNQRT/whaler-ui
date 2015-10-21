angular.module('whaler.directives').directive 'toggleSwitch', [ ()->
  restrict: 'AE'
  scope:
    ngModel: '='
    disabled: '='


  link : ($scope, $el, $attr, $ctrl, $transclude) ->
    inputId = $attr.id || ('switch_' + (new Date()).getTime())

    $el.find('label').attr 'for', inputId
    $el.find('input').attr 'id', inputId
    $el.removeAttr 'id'

    $scope.disabled ||= false

  template: """
    <input type="checkbox" hidden="hidden" ng-model="ngModel" ng-disabled="{{disabled}}">
    <label></label>
  """
]
