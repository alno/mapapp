class IndexController < ApplicationController

  def index
    render :layout => 'map'
  end

  def search
    render :text => render_cell(:search, :results, params)
  end

end
