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
    return if request.xhr?
    respond_to do |format|
      format.html { render 'application/index', layout: 'application' }
    end
  end
end
