class TestController < ApplicationController

def index
  @match = Match.new(UrfMatch.offset(rand(UrfMatch.count)).first.response)

  @presenter = {
    match: @match,
    title: 'foobar'
  }

  if request.xhr?
    render :json => @presenter
  end
end

end
