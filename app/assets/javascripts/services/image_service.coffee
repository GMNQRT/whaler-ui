angular.module('whaler.services').service 'ImageService', [
  '$q'
  'ImageFactory'
  'WebSocket'
  ImageService = (@$q, @ImageFactory, @WebSocket) ->
    @images = @ImageFactory.query()
    return
]

ImageService::reload = () ->
  @images = @ImageFactory.query()

ImageService::bindTo = (@$scope) ->
  @imagesChannel = @WebSocket.subscribe('image') unless @imagesChannel # Watch images events
  @imagesChannel.bind 'event', (data) => @$scope.$apply(@updateImage.call(@, data)) if @images

  @$scope.$on '$destroy', () =>
    @WebSocket.unsubscribe(@imagesChannel.name)
    @imagesChannel = null


# Subscribe to events fired by this service
ImageService::subscribe = (event_name, callback) ->
  handler = @$scope.$on("imageService.#{event_name}", callback)
  @$scope.$on '$destroy', handler
  return handler

ImageService::notify = (event_name, data...) ->
  @$scope.$emit "imageService.#{event_name}", data...

ImageService::start = (image) ->
  return @unpause image if image.info.State.Paused
  @ImageFactory.start(id: image.id).$promise

ImageService::remove = (image) ->
  @ImageFactory.delete(id: image.id).$promise

# Update images' informations through websocket
ImageService::updateImage = (data) ->
  if data.event.status is 'create'
    @images.push data.image
  else
    for image, i in @images when image.id == data.event.id
      if data.event.status is 'destroy'
        @images.splice i, 1
      else
        @images[i] = data.image
        @images[@selectedImage].active = true if @images[@selectedImage]?.id == image.id
      return
  return

# Display image informations on right pane
ImageService::select = (image) ->
  if @images[@selectedImage]
    return if image.id == @images[@selectedImage].id # Quit if same image is selected
  @selectedImage = @images.indexOf(image)

  if @images[@selectedImage]
    if @images[@selectedImage].info.ContainerConfig
      @notify 'select', @images[@selectedImage]
      @$q.resolve(@images[@selectedImage])
    else
      @ImageFactory.get(@images[@selectedImage], (image) =>
        angular.merge @images[@selectedImage], image
        @notify 'select', @images[@selectedImage]
      ).$promise
