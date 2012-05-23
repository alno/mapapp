
length = (path) ->
  points = path.getLatLngs()
  len = 0

  for i in [1..points.length-1]
    len += points[i-1].distanceTo points[i]

  len

distanceString = (dist) ->
  if dist > 2000
    Math.round(dist/100)/10 + " км"
  else if dist > 5
    Math.round(dist) + " м"
  else
    dist + " м"

@L.Control.Distance = @L.Control.extend

  options:
    position: 'topleft'

  onAdd: (map) ->
    className = 'leaflet-control-measure'
    container = L.DomUtil.create('div', className)

    link = L.DomUtil.create('a', className, container)
    link.href = '#'
    link.title = "Start measuring distance"

    lengthPopup = new L.Popup();\
    lengthPopup.closing = true

    closeLengthPopup = ->
      map.closePopup lengthPopup if lengthPopup.closing

    path = new L.Polyline([])
    path.on "mouseover", (e) ->
      lengthPopup.setLatLng e.latlng
      map.openPopup lengthPopup
      lengthPopup.closing = false

    path.on "mouseout", (e) ->
      lengthPopup.closing = true
      setTimeout closeLengthPopup, 600

    path.on 'edit', ->
      lengthPopup.setContent(distanceString(length(path)))

    map.addLayer(path)

    addMeasurePoint = (e) ->
      path.addLatLng(e.latlng)
      path.editing.disable()
      path.editing.enable()
      path.fire('edit')

    L.DomEvent
      .addListener(link, 'click', L.DomEvent.stopPropagation)
      .addListener(link, 'click', L.DomEvent.preventDefault)
      .addListener(link, 'click', ->
        if (L.DomUtil.hasClass(link, 'active'))
          L.DomUtil.removeClass(link, 'active')

          map.removeEventListener('click', addMeasurePoint)
          path.editing.disable()
        else
          L.DomUtil.addClass(link, 'active')

          map.addEventListener('click', addMeasurePoint)
          path.editing.enable()
      )

    container
