class BuildingsController < ApplicationController

  def show
    @building = OsmBuilding.find params[:id]
  end

end
