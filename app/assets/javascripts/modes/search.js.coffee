
class @App.Search

  constructor: (@app) ->

  enter: ->

  exit: ->

  route: (params) ->
    queryHash = "#{params.lat}/#{params.lon}/#{params.query}/#{params.categories}"

    if queryHash != @lastQueryHash
      requery = params.query != @lastQuery

      @lastQueryHash = queryHash
      @lastQuery = params.query

      $.get "/search.json", {lat: params.lat, lng: params.lon, q: params.query, categories: params.categories}, (data) =>
        @updateSearchResults(data)
        @app.showSidebar() if requery

      if requery
        $.get "/counts.json", {q: params.query}, (data) =>
          @updateSearchCounts(data)

  updateSearchResults: (data) ->
    map = @app.map
    sidebar = @app.sidebar

    if @searchResultsLayer
      map.removeLayer(@searchResultsLayer)
      @searchResultsLayer = null

    sidebar.find('.results').html('')
    sidebar.find('.pagination').html('')

    if data.results
      $('#search_form .search-query').val(data.query)

      if data.results.length == 0
        sidebar.find('.results').text(I18n.t('search.results.nothing_found'))
      else
        @searchResultsLayer = new L.LayerGroup()

        ul = $('<ul class="search-results">')
        ul.append(@buildResult(result)) for result in data.results
        ul.appendTo(sidebar.find('.results'))

        App.Utils.buildPaginator sidebar.find('.pagination'), data.current_page, data.page_count, (page) =>
          $.getJSON "/search", jQuery.extend(data.params, page: page), (newData) =>
            @updateSearchResults(newData)
          false

        map.addLayer @searchResultsLayer
    else
      sidebar.find('.results').text(I18n.t("search.no_query"))

  buildResult: (result) ->
    res = new App.Search.Result(@app, result)
    @searchResultsLayer.addLayer(res.getMarker())
    res.getNode()

  updateSearchCounts: (data) ->
    sidebar = @app.sidebar
    sidebar.find('.category_total .count').text(data.category_counts.all)
    sidebar.find('.category').each ->
      cat = $(@)

      if count = data.category_counts[parseInt(cat.data('id'))]
        cat.find('.count').text(count)
        cat.removeClass('empty')
        cat.find('a').attr('href', "#categories=#{cat.data('id')}")
      else
        cat.find('.count').text('')
        cat.addClass('empty')
        cat.find('a').attr('href', null)

    sidebar.find('#sidebar_results_tab').tab('show')
