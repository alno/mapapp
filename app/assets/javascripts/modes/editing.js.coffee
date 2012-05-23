class @App.Editing

  constructor: (@app) ->
    mode = @
    @app.sidebar.find('.edit_tools li a').click ->
      mode.switchTool $(@).data('tool')
      false

    @setupTools()

  enter: ->

  exit: ->

  switchTool: (tool) ->
    if @tool
      @tools[@tool].exit()
      @app.sidebar.find(".edit_tools li.#{@tool}").removeClass('active')

    if @tool == tool
      @tool = null
    else
      @tool = tool
      @tools[@tool].enter()
      @app.sidebar.find(".edit_tools li.#{@tool}").addClass('active')

  setupTools: ->
    @tools =
      marker: new App.Editing.MarkerTool(@)
      polyline: new App.Editing.PolylineTool(@)
      polygon: new App.Editing.PolygonTool(@)

class @App.Editing.MarkerTool

  constructor: (@mode) ->
    @app = @mode.app
    @map = @app.map

  enter: ->
    @map.on 'click', @onMapClick

  exit: ->
    @map.off 'click', @onMapClick

  onMapClick: (e) =>
    m = new L.Marker(e.latlng)
    @map.addLayer(m)

class @App.Editing.PolylineTool

  constructor: (@mode) ->
    @app = @mode.app
    @map = @app.map

  enter: ->
    @line = null
    @map.on 'click', @onMapClick

  exit: ->
    @line.editing.disable() if @line

    @map.off 'click', @onMapClick

  onMapClick: (e) =>
    @createPolyline() unless @line

    @line.addLatLng(e.latlng)
    @line.editing.disable()
    @line.editing.enable()
    @line.fire('edit')

  createPolyline: ->
    line = @line = new L.Polyline([])
    line.on 'dblclick', =>
      if line.editing.enabled()
        line.editing.disable()
      else
        line.editing.enable()

    @map.addLayer(line)

class @App.Editing.PolygonTool

  constructor: (@mode) ->
    @app = @mode.app
    @map = @app.map

  enter: ->
    @poly = null
    @map.on 'click', @onMapClick

  exit: ->
    if @poly
      @poly.editing.disable()
      @poly = null

    @map.off 'click', @onMapClick

  onMapClick: (e) =>
    @createPolygon() unless @poly

    @poly.addLatLng(e.latlng)
    @poly.editing.disable()
    @poly.editing.enable()
    @poly.fire('edit')

  createPolygon: ->
    poly = @poly = new L.Polygon([])
    poly.on 'dblclick', =>
      if poly.editing.enabled()
        poly.editing.disable()
      else
        poly.editing.enable()

    @map.addLayer(poly)
