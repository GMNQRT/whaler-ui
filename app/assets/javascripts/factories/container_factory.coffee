angular.module('whaler.factories').service 'ContainerFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('container/:id'),
    id: '@id'
    format: 'json'
  ,
    show: { url: API.generateResourceUrl('container/:id'), params: {id: '@id'}, method:'GET'}
    start: { url: API.generateResourceUrl('container/:id/start'), params: {id: '@id'}, method:'GET'}
    stop: { url: API.generateResourceUrl('container/:id/stop'), params: {id: '@id'}, method:'GET'}
    pause: { url: API.generateResourceUrl('container/:id/pause'), params: {id: '@id'}, method:'GET'}
    unpause: { url: API.generateResourceUrl('container/:id/unpause'), params: {id: '@id'}, method:'GET'}
    restart: { url: API.generateResourceUrl('container/:id/restart'), params: {id: '@id'}, method:'GET'}
    delete: { url: API.generateResourceUrl('container/:id'), params: {id: '@id'}, method:'DELETE'}
]