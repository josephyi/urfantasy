class ChampionsController < ApplicationController

  def show
    if request.xhr?
      if StaticData::CHAMPIONS_ID_TO_NAME.has_key?(params[:champion_id].to_i)
        render :json => UrfDayStat.aggregate(champion_id:params[:champion_id])
      else
        render :json => {server_error: 'no champion you idiot'}
      end
    end
  end

end