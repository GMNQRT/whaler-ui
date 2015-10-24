angular.module('whaler.filters').filter 'timeAgo', ['$interval', ($interval) ->
  $interval (() -> ), 60000

  fromNowFilter = (time) ->
    return unless time
    now = new Date()
    cur = new Date(time)

    return "#{diff}y" if (diff = now.getYear() - cur.getYear()) > 0
    return "#{diff}m" if (diff = now.getMonth() - cur.getMonth()) > 0
    return "#{diff}d" if (diff = now.getDate() - cur.getDate()) > 0
    return "#{diff}h" if (diff = now.getHours() - cur.getHours()) > 0

    diff = now.getMinutes() - cur.getMinutes()
    return "#{diff}min"

  fromNowFilter.$stateful = true
  return fromNowFilter
]
