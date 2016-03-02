angular.module('whaler.services').service 'SearchService', [
  '$rootScope'
  SearchService = ($rootScope) ->
    @query       = ''
    @tpl         = ''
    @defaultTpl  = ''
    @showResults = false

    $rootScope.$on '$routeChangeSuccess', () =>
      @defaultTpl  = ''

    return
]

SearchService::setDefaultTpl = (tpl) ->
  @defaultTpl = tpl

SearchService::paneIsVisible = () ->
  return @showResults

SearchService::showPane = (tpl) ->
  if !@showResults and (@defaultTpl or tpl)
    @tpl = tpl || @defaultTpl
    @showResults = true

SearchService::hidePane = () ->
  @tpl         = ''
  @query       = ''
  @showResults = false
