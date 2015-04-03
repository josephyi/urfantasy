module ApiSettings
  REQUESTS = ENV.fetch('RIOT_API_REQUESTS', 9)
  PERIOD = ENV.fetch('RIOT_API_PERIOD', 10)

  THROTTLE = { threshold: REQUESTS, period: PERIOD.to_i.seconds, key: 'riot_api_rate_limit' }

end