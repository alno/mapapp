class IndexController < ApplicationController

  def search
    @search = Search.new(params)
  end

end
