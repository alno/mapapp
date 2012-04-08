#= require spine
#= require spine/route

class @App extends Spine.Controller

  constructor: ->
    super

    @sidebar = $('#sidebar')
    @content = $('#content')

    $('#map').each =>
      @map = new L.Map('map')
      @map.addControl(new L.Control.Distance())
      @map.setView(new L.LatLng(54.5302,36.2597,1), 12)

    app = @
    $('#style_switch button').click ->
      $(@).button('toggle')
      app.selectStyle($(@).data('style'))

    $('#style_switch button').first().click()

    @setupRoutes()
    Spine.Route.setup()

  selectStyle: (style) ->
    @styleLayerCache = {} unless @styleLayerCache

    unless @styleLayerCache[style]
      @styleLayerCache[style] = new L.TileLayer "http://map.alno.name/tiles/#{style}/{z}/{x}/{y}.png",
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
        minZoom: 8
        maxZoom: 18

    @map.addLayer(@styleLayerCache[style])
    @map.removeLayer(layer) for s, layer of @styleLayerCache when s != style

  routeSearch: (params) =>
    redir = false

    for key in ['lat', 'lng', 'q']
      if params[key] == 'cur'
        params[key] = @currentSearch && @currentSearch[key]
        redir = true

    if params.q and params.q.match(/%\w{2}%/)
      params.q = decodeURIComponent(params.q)
      redir = true

    if params.lat == 'cur'
      params.lat = @currentSearch?.lat
      redir = true

    unless parseFloat(params.lat)
      params.lat = app.map.getCenter().lat
      redir = true

    unless parseFloat(params.lng)
      params.lng = app.map.getCenter().lng
      redir = true

    if redir
      @navigate('search', params.lat, params.lng, params.q, params.categories)
    else
      @currentSearch = params

      $.get "/search.json", params, (data) =>
        @updateSearchResults(data)

  setupRoutes: ->
    @routes
      "search/:lat/:lng/:q": @routeSearch
      "search/:lat/:lng/:q/:categories": @routeSearch

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

  updateSearchResults: (data)->
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

        @buildPaginator @sidebar.find('.pagination'), data.current_page, data.page_count, (page) =>
          $.getJSON "/search", jQuery.extend(data.params, page: page), (newData) =>
            @updateSearchResults(newData)
          false

        @map.addLayer @searchResultsLayer

    else
      @sidebar.find('.results').text(I18n.t("search.no_query"))

    @sidebar.find('.category').each ->
      cat = $(@)

      if count = data.category_counts[parseInt(cat.data('id'))]
        cat.find('.count').text(count)
        cat.removeClass('empty')
        cat.find('a').attr('href', "#search/#{data.params.lat}/#{data.params.lng}/#{data.query || ''}/#{cat.data('id')}")
      else
        cat.find('.count').text('')
        cat.addClass('empty')
        cat.find('a').attr('href', null)

    @sidebar.find('#sidebar_results_tab').tab('show')
    @showSidebar()

  buildPaginator: (container, current, count, handler) ->
    appendLink = (page) ->
      link = $("<a href=\"#\">#{page}</a>")
      link.click ->
        handler(page)

      container.append($("<span />").append(link))

    appendGap = ->
      container.append("<span class=\"disabled\"><a href=\"#\" onlick=\"return false\">...</a></span>")

    appendActive = (page) ->
      container.append("<span class=\"active\"><a href=\"#\" onlick=\"return false\">#{page}</a></span>")

    size = 2
    container.html("")

    return if count <= 1

    appendLink(1) if current - size > 1
    appendGap() if current - size > 2

    if current > 1
      appendLink(page) for page in [Math.max(current-size,1)..current-1]

    appendActive(current)

    if current < count
      appendLink(page) for page in [current+1..Math.min(current+size,count)]

    appendGap() if current + size < count - 1
    appendLink(count) if current + size < count

  findCategories: (table, types) ->
    cat for cat in metadata.categories when cat.table == table and _.any(cat.types, (ctype) -> _.include(types, ctype))

  buildResult: (result) ->
    res = new SearchResult(@, result)
    @searchResultsLayer.addLayer(res.getMarker())
    res.getNode()

  buildIcon: (url) ->
    @iconCache = {} unless @iconCache
    return @iconCache[url] if @iconCache[url]

    iconClass = L.Icon.extend
      options:
        iconUrl: url
        iconSize: new L.Point(32, 37)
        iconAnchor: new L.Point(16, 35)
        shadowUrl: '/images/marker-shadow.png'
        shadowSize: new L.Point(50, 35)
        popupAnchor: new L.Point(0, -25)

    new iconClass()

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
