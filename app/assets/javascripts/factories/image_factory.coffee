angular.module('whaler.factories').service 'ImageFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('image/:id'),
    id: '@id'
    format: 'json'
  ,
    search: { url: API.generateResourceUrl('image/search'), method:'GET', isArray: true }
    delete: { url: API.generateResourceUrl('image/:id'), params: {id: '@id'}, method:'DELETE'}
    run: { url: API.generateResourceUrl('image/:id/run'), params: {id: '@id'}, method:'POST'}
]
