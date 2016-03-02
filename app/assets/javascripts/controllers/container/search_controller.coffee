angular.module('whaler.controllers').controller 'Container.SearchController', [
  '$scope',
  '$timeout'
  'SearchService',
  'ImageFactory'
  SearchController = ($scope, $timeout, @SearchService, @ImageFactory) ->
    debounce = null

    $scope.$watch (() => return @SearchService.query), (term) =>
      @images = [] if term.length < 2
      $timeout.cancel debounce
      if term.length > 2
        debounce = $timeout () =>
          @getImages @SearchService.query if @SearchService.query.length > 2
        , 700
    return
]

SearchController::getImages = (query) ->
  @query = query
  @ImageFactory.search term: query, (results) =>
    @images = results


SearchController::run = (image) ->
  image.$loading = @ImageFactory.run image
