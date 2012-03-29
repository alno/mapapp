class BuildingsController < ApplicationController

  def show
    @building = OsmBuilding.find params[:id]
  end

  def info
    @building = OsmBuilding.find params[:id]
    @title = @building.address

    render :layout => 'info'
  end

end
