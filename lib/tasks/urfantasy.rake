


namespace :urfantasy do

  # give rito some time to have data ready
  OFFSET = 600

  # urf start time
  START_TIME = 1427866200

  # urf end time
  END_TIME = 1429340400

  # Endpoint has new data every 5 minutes
  INTERVAL_SECONDS = 300

  # Aggregate
  AGGREGATOR_OFFSET = 1.hour.to_i + OFFSET
  # Start Aggregating
  AGGREGATOR_START_TIME = ENV.fetch('AGGREGATOR_START_TIME', 1427864400)
  # Stop Aggregating
  AGGREGATOR_END_TIME = ENV.fetch('AGGREGATOR_END_TIME', 1429340400)

  desc 'queue entire range'
  task queue_all: :environment do
    (START_TIME..END_TIME).step(INTERVAL_SECONDS) do |bucket_time|
      Zilean.perform_at(bucket_time + OFFSET, bucket_time)
    end
  end

  desc 'queue aggregator'
  task aggregate: :environment do
    (AGGREGATOR_START_TIME..AGGREGATOR_END_TIME).step(AGGREGATOR_INTERVAL_SECONDS) do |bucket_time|
      Bard.perform_at(bucket_time + AGGREGATOR_OFFSET, bucket_time)
    end
  end

end