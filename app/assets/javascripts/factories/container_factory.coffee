angular.module('whaler.factories').service 'ContainerFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('container/:id'),
    id: '@id'
    format: 'json'
  ,
    search: { url: API.generateResourceUrl('image/search'), method:'GET', isArray: true }
]