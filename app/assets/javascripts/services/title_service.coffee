angular.module('whaler.services').service 'TitleService', [
  '$rootScope'
  TitleService = ($rootScope) ->
    @title       = ''

    $rootScope.$on '$routeChangeSuccess', ($event, $route) =>
      @title = $route.title

    return
]

TitleService::setTitle = (titles...) ->
  @title = titles.join '<i class="material-icons">keyboard_arrow_right</i>'

TitleService::getTitle = () ->
  return @title
