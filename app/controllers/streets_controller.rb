class StreetsController < ApplicationController

  def show
    @street = OsmStreet.find params[:id]
  end

  def info
    @street = OsmStreet.find params[:id]
    @title = @street.name

    render :layout => 'info'
  end

end
