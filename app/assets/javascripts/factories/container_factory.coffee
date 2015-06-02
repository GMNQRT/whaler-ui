angular.module('whaler.factories').service 'ContainerFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('container/:id'),
    id: '@id'
    format: 'json'
  ,
]