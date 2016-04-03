angular.module('whaler.filters').filter 'containerBy', [
  'ContainerService'
  (ContainerService) ->
    # Resolve property of given object
    resolve = (path, obj, safe) ->
      path.split('.').reduce((prev, curr) ->
        if !safe then prev[curr] else (if prev then prev[curr] else undefined)
      , obj || self)

    (input, name) ->
      for container in ContainerService.containers when input == resolve(name, container, true)
        return container
      return null

]
