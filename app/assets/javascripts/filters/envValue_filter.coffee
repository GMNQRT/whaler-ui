angular.module('whaler.filters').filter 'envValue', [() ->
  (input) ->
    return input.substr(input.indexOf('=') + 1)
]