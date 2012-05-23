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
        @app.updateSearchResults(data)
        @app.showSidebar() if requery

      if requery
        $.get "/counts.json", {q: params.query}, (data) =>
          @updateSearchCounts(data)

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
