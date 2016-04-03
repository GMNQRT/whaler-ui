angular.module('whaler.filters').filter 'linksFormat', [() ->
  (input) =>
    output    = {}
    tmpOutput = {}

    if input
      for link in input
        linkValues = link.split ':'
        container  = linkValues[0]

        if m = linkValues[1].match(/([^\/]+)\/([^@]+)(?:@(.*))?/)
          category = if m[3] then m[2] else 'default'
          alias    = m[3] || m[2]

          tmpOutput[container] ||= {}
          delete tmpOutput[container].default if tmpOutput[container].default
          if Object.keys(tmpOutput[container]).length == 0
            tmpOutput[container][category] = alias

    # if no links found
    if angular.equals tmpOutput, {}
      output.default = {}
    # else format output
    else
      for container, categories of tmpOutput
        for category, alias of categories
          output[category] ||= {}
          output[category][container] ||= []
          output[category][container].push alias

    if !angular.equals(output, @output)
      @output = output
    return @output
]
