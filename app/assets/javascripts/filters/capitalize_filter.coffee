angular.module('whaler.filters').filter 'capitalize', [() ->
  (input) ->
    return input.substring(0,1).toUpperCase()+input.substring(1);
]