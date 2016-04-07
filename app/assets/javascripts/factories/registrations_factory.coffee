angular.module('whaler.factories').service 'RegistrationsFactory', ['$resource', 'API', ($resource, API) ->
  $resource API.generateResourceUrl('admin_registrations/:id'),
    id: '@id'
    format: 'json'
   ,
    updateUser: { url: API.generateResourceUrl('admin_registrations/:id'), params: { id: '@id' }, method:'PUT' }
]
