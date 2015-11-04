angular.module('whaler.controllers').controller 'ImageController', [
  '$scope'
  'ImageService'
  ImageController = (@$scope, @ImageService) ->
    return
]

ImageController::indexAction = () ->
  return

ImageController::select = (container) ->
  console.log container
