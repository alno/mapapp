#= require jquery
#= require jquery_ujs
#= require_tree .

@app = {}

$ ->
  $('#map').each ->
    map = new L.Map('map')
    map.addControl(new L.Control.Distance())
    map.addLayer(Layers.base)
    map.setView(new L.LatLng(54.5302,36.2597,1), 12)

    map.on 'dblclick', (e) ->
      map.addLayer(new L.Marker(e.latlng))

  $('#sidebar_toggle').click ->
    sidebar = $('#sidebar')
    content = $('#content')

    if sidebar.offset().left >= 0
      content.removeClass('with-sidebar')
      sidebar.animate({left: - sidebar.width() - 10}, 200)
    else
      content.addClass('with-sidebar')
      sidebar.animate({left: 0}, 200)
