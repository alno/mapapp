#= require jquery
#= require jquery_ujs

#= require history_jquery
#= require_tree .

class Map

  constructor: ->
    @map = new L.Map('map')
    @map.addControl(new L.Control.Distance())
    @map.addLayer(Layers.base)
    @map.setView(new L.LatLng(54.5302,36.2597,1), 12)

    @map.on 'dblclick', (e) =>
      @map.addLayer(new L.Marker(e.latlng))

    @present = true

  showSearchResults: (coords) ->
    @map.removeLayer(@searchResultsLayer) if @searchResultsLayer
    @searchResultsLayer = new L.LayerGroup()

    for c in coords
      console.log(c)
      @searchResultsLayer.addLayer(new L.Marker(c))

    @map.addLayer @searchResultsLayer

$ ->
  sidebar = $('#sidebar')
  content = $('#content')

  showSidebar = ->
    if sidebar.offset().left < 0
      content.addClass('with-sidebar')
      sidebar.animate({left: 0}, 200)

  hideSidebar = ->
    if sidebar.offset().left >= 0
      content.removeClass('with-sidebar')
      sidebar.animate({left: - sidebar.width() - 10}, 200)

  $('#map').each ->
    window.map = new Map()

  $('#sidebar_toggle').click ->
    if sidebar.offset().left >= 0
      hideSidebar()
    else
      showSidebar()

  $('#search_form').submit ->
    return true unless map? and sidebar.length > 0

    # TODO Add sidebar loading
    # TODO Pushstate

    $.get "/search?#{$('#search_form').serialize()}", (data) ->
      $('#sidebar').html(data)
      showSidebar()

    false # Don't send form in normal way
