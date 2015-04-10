class UrfMatch < ActiveRecord::Base
  scope :in_region, -> region {where('region = ?', region)}
  scope :on_and_after, -> bucket_time {where('bucket_time  >= ?', bucket_time)}
  scope :before, -> bucket_time {where('bucket_time < ?', bucket_time)}
  scope :in_region_and_between,  -> region, start_time, end_time {in_region(region).on_and_after(start_time).before(end_time) }

end
