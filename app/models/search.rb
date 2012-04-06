class Search

  attr_reader :params, :query, :valid

  def initialize(params)
    @params = params
    @valid = !params[:q].blank? || !params[:categories].blank?
    @fields = nil

    if @valid
      @query = params[:q]
      @options = { :page => params[:page] || 1, :per_page => 12 }

      unless params[:lat].blank? || params[:lng].blank?
        @options[:geo] = [params[:lat].to_f / 180 * Math::PI, params[:lng].to_f / 180 * Math::PI]
        @options[:latitude_attr] = "latitude"
        @options[:longitude_attr] = "longitude"
        @options[:order] = "@geodist ASC, @relevance DESC"
      end

      unless params[:categories].blank?
        @options[:with] ||= {}
        @options[:with][:category_ids] = params[:categories].split(',')
      end

      unless @query.blank?
        if OsmPlace.search_count(query) > 0
          @fields = [:name, :keywords]
          Rails.logger.info "There are places in results, excluding address and city fields from search"
        elsif OsmStreet.search_count(query) > 0
          @fields = [:name, :keywords, :city]
          Rails.logger.info "There are streets in results, excluding address fields from search"
        end
      end

    else
      @query = nil
      @options = {}
    end
  end

  def results
    @valid && (@results ||= ThinkingSphinx.search(*search_args))
  end

  def category_counts
    @category_counts ||= counts_by('category_ids')
  end

  def self.empty
    @empty_search ||= Search.new({})
  end

  private

  def search_args
    if @fields
      [@options.merge(:conditions => { "(#{@fields.join(',')})" => @query })]
    else
      [@query, @options]
    end
  end

  def counts_by(attr)
    Hash[ThinkingSphinx.search(query, :group_function => :attr, :limit => 1000, :max_matches => 100000, :group_by => attr, :ids_only => true).results[:matches].map{|m| a = m[:attributes]; [a['@groupby'], a['@count']]}]
  end

end
