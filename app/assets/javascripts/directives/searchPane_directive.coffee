angular.module('whaler.directives').directive 'searchPane', [
  '$compile'
  'SearchService'
  ($compile, SearchService)->
    restrict: 'E'
    controller: () ->
    link : ($scope, $el, $attr) ->
      $scope.SearchService = SearchService

      $el.bind 'click', ($event) ->
        if angular.element($event.target).hasClass('searchPane-container')
          $scope.SearchService.hidePane()
          $scope.$apply()

    template: """<div class="searchPane-container" ng-if="SearchService.paneIsVisible()" ng-include="SearchService.tpl"></div>"""
]
