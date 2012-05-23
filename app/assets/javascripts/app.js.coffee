#= require osmjs.weather-layer
#= require jquery.bbq

#= require_self

#= require control-distance
#= require layer-photos
#= require search_result
#= require utils

#= require_tree ./modes

class @App

  constructor: ->
    @sidebar = $('#sidebar')
    @content = $('#content')

    @layers =
      photos: new PhotoLayer()
      weather: new OsmJs.Weather.LeafletLayer({lang: I18n.locale})

    @modes =
      validators: new App.Validators(@)
      search: new App.Search(@)

    @defaultMode = 'search'

    $('#map').each =>
      @map = new L.Map('map')
      @map.setView(new L.LatLng(metadata.config.map.init.lat, metadata.config.map.init.lng,1), metadata.config.map.init.zoom)
      @map.addControl(new L.Control.Distance())
      @map.addControl(new L.Control.Scale())
      @map.on 'popupopen', (e) ->
        setTimeout((-> e.popup._update()), 100)
        setTimeout((-> e.popup._update()), 300)
        setTimeout((-> e.popup._update()), 700)
        setTimeout((-> e.popup._update()), 1500)
      @map.on 'moveend', =>
        @navigate
          lat: @map.getCenter().lat
          lon: @map.getCenter().lng
          zoom: @map.getZoom()

    app = @
    $('#style_switch button').click ->
      $(@).button('toggle')
      app.selectStyle($(@).data('style'))

    $('#style_switch button').first().click()

    $('#layer_checks button').click ->
      layer = app.layers[$(@).data('layer')]

      if $(@).hasClass('active')
        app.map.removeLayer(layer)
      else
        app.map.addLayer(layer)

    @lastParams = {}
    @setupRoutes()

  setupRoutes: ->
    w = $(window)
    w.bind 'hashchange', =>
      @route $.deparam((location.hash or '').slice(1))
    w.trigger 'hashchange'

  navigate: (params, force = false) ->
    params = $.extend(@lastParams, params) unless force

    @lastParams = params
    location.hash = $.param(params)

  route: (params) ->
    changed = false

    unless parseFloat(params.lat)
      params.lat = @map.getCenter().lat
      changed = true

    unless parseFloat(params.lon)
      params.lon = @map.getCenter().lng
      changed = true

    unless parseInt(params.zoom)
      params.zoom = @map.getZoom()
      changed = true

    unless @modes[params.mode]
      params.mode = @defaultMode
      changed = true

    for k, v of @lastParams when typeof params[k] == 'undefined'
      params[k] = v
      changed = true

    return @navigate(params) if changed

    @lastParams = params
    @switchMode(params.mode)

    unless parseFloat(params.lat) == @map.getCenter().lat and parseFloat(params.lon) == @map.getCenter().lng and parseInt(params.zoom) == @map.getZoom()
      @map.setView(new L.LatLng(params.lat, params.lon,1), params.zoom)

    @modes[params.mode].route(params) if @modes[params.mode].route

  selectStyle: (style) ->
    @styleLayerCache = {} unless @styleLayerCache

    unless @styleLayerCache[style]
      @styleLayerCache[style] = new L.TileLayer "#{metadata.config.map.style_base}/#{style}/{z}/{x}/{y}.png",
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
        minZoom: metadata.config.map.min_zoom
        maxZoom: metadata.config.map.max_zoom

    @map.addLayer(@styleLayerCache[style])
    @map.removeLayer(layer) for s, layer of @styleLayerCache when s != style

  switchMode: (name) ->
    $('#mode_select a.dropdown-toggle span').text(I18n.t("#{name}.label"))
    $('.mode_dependent').hide()
    $(".mode_#{name}").show()

    mode.exit() for key, mode of @modes when key != name
    @modes[name].enter()

  showSidebar: ->
    if @sidebar.offset().left < 0
      @content.addClass('with-sidebar')
      @sidebar.animate({left: 0}, 200)

  hideSidebar: ->
    if @sidebar.offset().left >= 0
      @content.removeClass('with-sidebar')
      @sidebar.animate({left: -400}, 200)

  showSelectionLayer: (layer) ->
    @hideSelectionLayer()

    @selectionLayer = layer
    @map.addLayer(@selectionLayer)

  hideSelectionLayer: ->
    if @selectionLayer
      @map.removeLayer(@selectionLayer)
      @selectionLayer = null

  updateSearchResults: (data) ->
    if @searchResultsLayer
      @map.removeLayer(@searchResultsLayer)
      @searchResultsLayer = null

    @sidebar.find('.results').html('')
    @sidebar.find('.pagination').html('')

    if data.results
      $('#search_form .search-query').val(data.query)

      if data.results.length == 0
        @sidebar.find('.results').text(I18n.t('search.results.nothing_found'))
      else
        @searchResultsLayer = new L.LayerGroup()

        ul = $('<ul class="search-results">')
        ul.append(@buildResult(result)) for result in data.results
        ul.appendTo(@sidebar.find('.results'))

        App.Utils.buildPaginator @sidebar.find('.pagination'), data.current_page, data.page_count, (page) =>
          $.getJSON "/search", jQuery.extend(data.params, page: page), (newData) =>
            @updateSearchResults(newData)
          false

        @map.addLayer @searchResultsLayer

    else
      @sidebar.find('.results').text(I18n.t("search.no_query"))

  findCategories: (table, types) ->
    cat for cat in metadata.categories when cat.table == table and _.any(cat.types, (ctype) -> _.include(types, ctype))

  buildResult: (result) ->
    res = new SearchResult(@, result)
    @searchResultsLayer.addLayer(res.getMarker())
    res.getNode()

  showPopup: (data) ->
    @prevPopup.modal('hide') if @prevPopup

    popup = $("<div class=\"modal\"><div class=\"modal-header\"><a class=\"close\" data-dismiss=\"modal\">×</a><h3></h3></div><div class=\"modal-body\" /></div>")
    popup.find('.modal-header h3').html(data.title)
    popup.find('.modal-body').html(data.body)
    popup.appendTo('body')
    popup.modal(backdrop: false)
    popup.on 'hidden', ->
      popup.remove()
      @prevPopup = null

    @prevPopup = popup

  showPage: (path) ->
    $.get "/#{path}.json", (data) =>
      @showPopup(data)

  showInfo: (table, id) ->
    $.get "/#{table}/#{id}.json", (data) =>
      @showPopup title: data.name, body: data.info
