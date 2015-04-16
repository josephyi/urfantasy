class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :render_default_view

  def index
  end

  private

  # intercept all non ajax requests
  def render_default_view
    return if request.xhr? || params[:format]
    respond_to do |format|
      format.html { render 'application/index', layout: 'application' }
    end
  end

  def data_cache(key, time=2.minutes)
    return yield if  ActionController::Base.perform_caching.blank?
    output = Rails.cache.fetch(key, {expires_in: time}) do
      yield
    end
    return output
  rescue
    return yield
  end
end
