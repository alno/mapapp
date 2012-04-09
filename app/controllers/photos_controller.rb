class PhotosController < ApplicationController

  def index
    @photos = Photo.limit(30)

    if bbox = params[:bbox].split(',')
      @photos = @photos.in_bbox(bbox)
    end
  end

end
