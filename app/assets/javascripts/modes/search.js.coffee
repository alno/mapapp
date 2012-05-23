class @App.Search

  constructor: (@app) ->

  enter: ->

  exit: ->

  route: (params) ->
    queryHash = "#{params.lat}/#{params.lon}/#{params.query}"

    if queryHash != @lastQueryHash
      reopenResults = params.query != @lastQuery

      @lastQueryHash = queryHash
      @lastQuery = params.query

      $.get "/search.json", {lat: params.lat, lng: params.lon, q: params.query}, (data) =>
        @app.updateSearchResults(data)
        @app.showSidebar() if reopenResults
