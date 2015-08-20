angular.module('whaler.factories').factory 'StreamFactory', [() ->
  listen: (source) =>
    console.log "listenTo"
    @source = new EventSource(source);

    return (
      $on: (type, callback, $scope = null) =>
        @source.addEventListener type, if angular.isObject($scope) then (e) => $scope.$apply(callback(e)) else callback

      destroy: () =>
        console.log "close"
        @source.close()
    )
]