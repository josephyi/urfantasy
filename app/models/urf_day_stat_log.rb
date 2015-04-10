class UrfDayStatLog < ActiveRecord::Base
  scope :region, -> region { where('region = ?', region)}
  scope :day, -> day { where('urf_day = ?', day)}
  scope :hour, -> hour { where('hour_in_day = ?', hour)}
  scope :matches_sum, -> {sum(:matches)}
end
