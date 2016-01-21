angular.module('whaler.filters').filter 'split', [() ->
  (input, splitChar, splitIndex) ->
    return input.split(splitChar)[splitIndex];
]