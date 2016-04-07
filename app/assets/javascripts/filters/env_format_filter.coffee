angular.module('whaler.filters').filter 'envFormat', [() ->
  (input) =>
    output = []
    if input
      for str in input
        splitStr = str.split('=')
        output.push {
          key: splitStr[0]
          value: splitStr[1]
        }

    if !angular.equals(output, @output)
      @output = output
    return @output
]
