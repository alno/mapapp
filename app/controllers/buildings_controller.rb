class BuildingsController < ApplicationController

  def show
    @building = OsmBuilding.find params[:id]
  end

  def page
    @building = OsmBuilding.find params[:id]
    @title = @building.address

    render :layout => 'page'
  end

end
