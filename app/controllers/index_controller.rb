class IndexController < ApplicationController

  def search
    @search = Search.search(params)
  end

end
