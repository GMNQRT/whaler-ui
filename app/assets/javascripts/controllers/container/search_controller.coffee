angular.module('whaler.controllers').controller 'Container.SearchController', [
  '$scope',
  '$timeout'
  'SearchService',
  'ImageFactory'
  SearchController = ($scope, @$timeout, @SearchService, @ImageFactory) ->
    $scope.$watch (() => return @SearchService.query), (term) =>
      @getImages term
    return
]

SearchController::getImages = (query) ->
  if query.length < 2
    @images = []
  else
    @query = query
    @$timeout.cancel @queryTimeout if @queryTimeout
    @queryTimeout =  @$timeout () =>
      @ImageFactory.search term: query, (results) =>
        @images = results
    , 700


SearchController::run = (image) ->
  image.$loading = @ImageFactory.run image
