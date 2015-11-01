angular.module('whaler.controllers').controller 'ImageController', [
  '$scope'
  'ImageService'
  ImageController = (@$scope, @ImageService) ->
    return
]

ImageController::indexAction = () ->
  console.log @ImageService.images
# ImageController::searchImage = (val, $event) ->
#   $event?.preventDefault()
#   return if !val || val.length == 0
#
#   @ImageFactory.search { term: val }, (images) =>
#     @images = images
#
# ImageController::getThumbText = (image) ->
#   switch
#     when image.info.is_official then 'Official'
#     when image.info.is_trusted then 'Trusted'
#     else 'Unknow'
#
# ImageController::runImage = (image) ->
#   console.log image
#
#   @ImageFactory.save { fromImage: image.id }, (images) =>
#     console.log images
