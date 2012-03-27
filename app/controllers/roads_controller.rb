class RoadsController < ApplicationController

  def show
    @road = OsmRoad.find params[:id]
  end

  def page
    @road = OsmRoad.find params[:id]
    @title = @road.name

    render :layout => 'page'
  end

end
