angular.module('whaler.filters').filter 'portBindingsFormat', [() ->
  (input) =>
    output = []
    if input
      for ContainerPort, HostConfig of input
        for binding in HostConfig
          output.push
            container:
              port: ContainerPort.substr 0, ContainerPort.indexOf('/')
              protocol: ContainerPort.substr(ContainerPort.indexOf('/') + 1)
            host:
              ip: binding.HostIp
              port: binding.HostPort

    if !angular.equals(output, @output)
      @output = output
    return @output
]
