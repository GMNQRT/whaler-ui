angular.module('whaler.filters').filter 'envKey', [() ->
  (input) ->
    return input.substr(0, input.indexOf('='))
]