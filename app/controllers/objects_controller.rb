class ObjectsController < ApplicationController

  def show
    @object = OsmObject.find params[:id]
  end

  def info
    @object = OsmObject.find params[:id]
    @title = @object.name

    render :layout => 'info'
  end

end
