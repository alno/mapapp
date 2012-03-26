class IndexController < ApplicationController

  def search
    @search = Search.search(params)

    puts @search.inspect
  end

end
