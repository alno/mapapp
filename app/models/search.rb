class Search

  attr_reader :params, :query

  def initialize(params)
    @params = params

    if params[:q].blank?
      @query = nil
      @options = {}
    else
      @query = params[:q]
      @options = { :page => params[:page] || 1, :per_page => 15 }

      unless params[:lat].blank? || params[:lng].blank?
        @options[:geo] = [params[:lat].to_f / 180 * Math::PI, params[:lng].to_f / 180 * Math::PI]
        @options[:latitude_attr] = "latitude"
        @options[:longitude_attr] = "longitude"
        @options[:order] = "@geodist ASC, @relevance DESC"
      end
    end
  end

  def results
    @query && (@results ||= ThinkingSphinx.search(query, @options))
  end

  def category_counts
    @category_counts ||= Hash[ThinkingSphinx.search(@options.merge(:group_function => :attr, :group_by => 'category_ids', :ids_only => true)).results[:matches].map{|m| a = m[:attributes]; [a['@groupby'], a['@count']]}]
  end

  def self.empty
    @empty_search ||= Search.new({})
  end

end
