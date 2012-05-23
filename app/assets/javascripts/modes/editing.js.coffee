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
    unless @line
      @line = new L.Polyline([])
      @map.addLayer(@line)

    @line.addLatLng(e.latlng)
    @line.editing.disable()
    @line.editing.enable()
    @line.fire('edit')

class @App.Editing.PolygonTool

  constructor: (@mode) ->
    @app = @mode.app
    @map = @app.map

  enter: ->
    @poly = null
    @map.on 'click', @onMapClick

  exit: ->
    @poly.editing.disable() if @poly

    @map.off 'click', @onMapClick

  onMapClick: (e) =>
    unless @poly
      @poly = new L.Polygon([])
      @map.addLayer(@poly)

    @poly.addLatLng(e.latlng)
    @poly.editing.disable()
    @poly.editing.enable()
    @poly.fire('edit')
