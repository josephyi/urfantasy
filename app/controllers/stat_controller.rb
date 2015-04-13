class StatController < ApplicationController
  respond_to :json

  before_filter :prepare_params

  def prepare_params
    @query ||= {region: params[:region], urf_day: params[:day], hour_in_day: params[:hour]}.compact
  end

  def urf
    UrfDayStat.aggregate(query)
  end

end
