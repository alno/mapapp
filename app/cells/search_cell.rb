class SearchCell < Cell::Rails

  append_view_path Rails.root.join('app/views')

  def results(params)
    unless params[:q].blank?
      @query = params[:q]

      options = { :page => params[:page] || 1, :per_page => 15 }

      unless params[:lat].blank? || params[:lng].blank?
        options[:geo] = [params[:lat].to_f / 180 * Math::PI, params[:lng].to_f / 180 * Math::PI]
        options[:latitude_attr] = "latitude"
        options[:longitude_attr] = "longitude"
        options[:order] = "@geodist ASC, @relevance DESC"
      end

      @results = ThinkingSphinx.search @query, options
    end

    render
  end

end
