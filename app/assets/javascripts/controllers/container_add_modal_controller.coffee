angular.module('whaler.controllers').controller 'Container.AddModalController', [
  'ImageFactory'
  ContainerAddModalController = (@ImageFactory) ->
    return
]


ContainerAddModalController::getImages = (query) ->
  return if query.length < 2
  @ImageFactory.search term: query, (results) =>
    @images = results
    console.log results
