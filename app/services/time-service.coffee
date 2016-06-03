module.exports =

  daysToMinutes: (days) -> days * 24 * 60


  getHumanTime: (minutes) ->
    minute = Math.floor minutes % 60
    hour = Math.floor(minutes / 60) % 24
    day = Math.floor(Math.floor(minutes / 60) / 24) + 1

    minuteString = "#{minute}"
    minuteString = "0#{minute}" if minute < 10
    "Day #{day} - #{hour}:#{minuteString}"
