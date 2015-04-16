class StatController < ApplicationController
  respond_to :json
  before_filter :prepare_params

  def prepare_params
    @query ||= {region: params[:region], urf_day: params[:day], hour_in_day: params[:hour], champion_id: params[:champion_id]}.compact
  end

  def urf
    respond_with UrfDayStat.aggregate_all(@query)
  end

  def champion
    Integer(params[:champion_id]) # lazy protection vs SQL injection lel
    respond_with UrfDayStat.aggregate_single(@query).merge(ReportService.champion_report(params[:champion_id]))
  end

end
