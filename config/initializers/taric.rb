require 'typhoeus/adapters/faraday'

Taric.configure! do |config|
  config.adapter = :typhoeus
end