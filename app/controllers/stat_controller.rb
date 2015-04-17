class StatController < ApplicationController
  respond_to :json
  before_filter :prepare_params

  def prepare_params
    raise ArgumentError if params[:region].present? && !StaticData::REGIONS.include?(params[:region])
    @query ||= {region: params[:region], urf_day: params[:day], hour_in_day: params[:hour], champion_id: params[:champion_id]}.compact
  end

  def urf
    result = data_cache(request.url, 120.minutes) do
      UrfDayStat.aggregate_all(@query)
    end
    respond_with result
  end

  def champion
    Integer(params[:champion_id]) # lazy protection vs SQL injection lel
    result = data_cache(request.url, 120.minutes) do
      UrfDayStat.aggregate_single(@query).merge!(ReportService.champion_report(params[:champion_id]))
    end
    respond_with result
  end
end
