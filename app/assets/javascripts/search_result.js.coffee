
class @SearchResult

  constructor: (@app, @data) ->

    @point = new L.LatLng(@data.lat, @data.lng)
    @cats = @app.findCategories(@data.table, @data.types)
    @icons = ("/images/icons-classic/#{cat.icon}.png" for cat in @cats when cat.icon)

  preloadExtendedData: ->
    $.get "/#{@data.table}/#{@data.id}.json", (data) =>
      @extendedData = data
      if @infoQueued
        @infoQueued = false
        @showInfo()
      if @geometryQueued
        @geometryQueued = false
        @showGeometry()

  showInfo: ->
    if @extendedData
      @app.showPopup title: @extendedData.name, body: @extendedData.info
    else
      @infoQueued = true

  showGeometry: ->
    if @extendedData
      if @extendedData.geojson
        @app.showSelectionLayer(new L.GeoJSON(type: 'Feature', geometry: @extendedData.geojson))
    else
      @geometryQueued = true

  hideGeometry: ->
    if @extendedData
      @app.hideSelectionLayer()

    @geometryQueued = false

  getMarker: ->
    return @marker if @marker

    markerOptions = {}
    markerOptions.icon = App.Utils.buildIcon(@icons[0]) if @icons.length > 0

    popupContent = $("<div><h3>#{@data.name}</h3><b>#{@data.address || ''}</b><p><a class=\"more\" href=\"#\" onclick=\"return false\">#{I18n.t 'info.links.more'}</a></p></div>")
    popupContent.find('a.more').click =>
      @showInfo()

    @marker = new L.Marker(@point, markerOptions)
    @marker.bindPopup popupContent[0]
    @marker.on 'popupopen', =>
      @preloadExtendedData()
      @showGeometry()
    @marker.on 'popupclose', =>
      @hideGeometry()
    @marker

  getNode: ->
    return @node if @node

    if @data.table == 'places'
      minZoom = 10
      maxZoom = 12
    else if @data.table == 'streets'
      minZoom = 13
      maxZoom = 15
    else
      minZoom = 16
      maxZoom = 18

    nodeStyle = {}
    nodeStyle.background = "url(#{@icons[0]}) no-repeat left center" if @icons.length > 0

    linkMore = $("<a class=\"name\" href=\"#\">#{@data.name}</a>")
    linkMore.click =>
      @app.map.panTo(@point)
      @app.map.setZoom(minZoom) if @app.map.getZoom() < minZoom
      @app.map.setZoom(maxZoom) if @app.map.getZoom() > maxZoom
      @getMarker().openPopup()
      false

    @node = $('<li class="search-result">')
    @node.append(linkMore)
    @node.append("<span class=\"address\">#{@data.address}</span>") if @data.address
    @node.css(nodeStyle)
    @node
