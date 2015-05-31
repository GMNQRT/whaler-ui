angular.module('whaler.controllers').controller 'ImageController', [
  '$scope',
  '$http',
  '$timeout',
  'ImageFactory',
  ($scope, $http, $timeout, ImageFactory) ->
    $scope.term = ''
    $scope.images = []
    $scope.$watch 'term', (val) ->
      return unless val || val.length > 0

      ImageFactory.search { term: val }, (images) ->
        $scope.images = images

    $scope.getThumbText = (image) ->
      switch
        when image.info.is_official then 'Official'
        when image.info.is_trusted then 'Trusted'
        else 'Unknow'
]