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
          @app.updateSearchCounts(data)
