angular.module('whaler.directives').directive 'formGroup', [ '$compile', ($compile)->
  restrict: 'AC'
  transclude: true
  priority: 1500
  require: ['formGroup', '^form']
  controllerAs: 'formGroupCtrl',
  scope: true
  controller: ($scope) ->
    @inputModel = {}

    @setInputModel = (inputModel) ->
      @inputModel = @form?[inputModel.$name]

    @setForm = (form) ->
      @form = form

    @setFocus = (value) ->
      @inputModel.hasFocus = value
      $scope.$apply()
    return

  compile: ($el, $attrs) ->
    $el.addClass 'form-group'
    $el.attr 'ng-class', """{
      'has-focus': formGroupCtrl.inputModel.hasFocus,
      'has-success': formGroupCtrl.inputModel.$valid && (formGroupCtrl.form.$submitted || formGroupCtrl.inputModel.$dirty),
      'has-error': formGroupCtrl.inputModel.$invalid && (formGroupCtrl.form.$submitted || formGroupCtrl.inputModel.$touched),
      'is-empty': !formGroupCtrl.inputModel.$viewValue
    }"""

    return ($scope, $wrapper, $wrapperAttrs, $ctrl, $transclude) ->
      $ctrl[0].setForm $ctrl[1]
      $compile($wrapper, null, 1500)($scope)
      $transclude $scope, (clone) ->
        $wrapper.append clone


]
.directive 'formControl', [ '$compile', ($compile)->
  restrict: 'AC'
  require: ['^formGroup', 'formControl', '?ngModel']
  controllerAs: 'formContentCtrl'
  scope: true
  bindToController:
    label: '@'
  controller: () ->
  link: ($scope, $el, $attrs, $ctrl, $transclude) ->
    if $ctrl[0]
      if $ctrl[1].label
        $el.before $compile('<label for="' + $attrs.id + '" class="control-label">{{ formContentCtrl.label }}</label>')($scope)

      $ctrl[0].setInputModel $ctrl[2] if $ctrl[2]
      $el.bind 'focus', () ->
        $ctrl[0].setFocus true
      $el.bind 'blur', () ->
        $ctrl[0].setFocus false
]
