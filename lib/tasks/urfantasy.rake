


namespace :urfantasy do
  # start of endpoint
  OFFSET = 600 # give rito some time to have data ready
  START_TIME = 1427866200
  #END_TIME = 1427867100

  END_TIME = 1429340400

  INTERVAL_SECONDS = 300
  desc 'queue entire range'
  task queue_all: :environment do
    (START_TIME..END_TIME).step(INTERVAL_SECONDS) do |bucket_time|
      Zilean.perform_at(bucket_time + OFFSET, bucket_time)
    end
  end
end