class ScoreboardController < ApplicationController

  def index
    @match = Match.new(UrfMatch.offset(rand(UrfMatch.count)).first.response)

    @presenter = {
      leaderboard: @match.leaderboard,
      title: 'Scoreboard'
    }

    if request.xhr?
      render :json => @presenter
    end
  end

  def top
    puts params[:day]
    presenter = {
      leaderboard: UrfDayStat.day_leaderboard(urf_day:params[:day])
    }
    if request.xhr?
      render :json => presenter
    end
  end

end