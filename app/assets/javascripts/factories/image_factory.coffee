angular.module('whaler.factories').service 'ImageFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('image/:id'),
    id: '@id'
    format: 'json'
  ,
    # last: { url: '"$$ baseAPI() $$"/articles/last', method:'GET', isArray: true }
    # related: { url: '"$$ baseAPI() $$"/articles/:slug/related', method:'GET', isArray: true }
]