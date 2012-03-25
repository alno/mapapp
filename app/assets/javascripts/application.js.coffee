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

  updateSearchResults: ->
    if @searchResultsLayer
      @map.removeLayer(@searchResultsLayer)
      @searchResultsLayer = null

    return if $('#sidebar .search-result').lenght == 0

    layer = new L.LayerGroup()
    map = @map

    $('#sidebar .search-result').each ->
      res = $(@)
      zoom = res.data('zoom')
      point = new L.LatLng(res.data('lat'), res.data('lng'))

      marker = new L.Marker(point)
      marker.bindPopup("<h3>#{res.find('.name').html()}</h3><b>#{res.find('.address').html()}</b>")

      layer.addLayer(marker)

      res.click ->
        map.panTo point
        map.setZoom zoom
        marker.openPopup()
        false

    @map.addLayer layer
    @searchResultsLayer = layer

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
      sidebar.animate({left: -400}, 200)

  updateSidebar = ->
    $('#sidebar .pagination a').click ->

      if page = $(@).data('page')
        center = map.map.getCenter()

        $.get "/search?#{$('#search_form').serialize()}&lat=#{center.lat}&lng=#{center.lng}&page=#{page}", (data) ->
          $('#sidebar').html(data)
          map.updateSearchResults()
          updateSidebar()
          showSidebar()

      false

  $('#map').each ->
    window.map = new Map()
    window.map.updateSearchResults()

  $('#sidebar_toggle').click ->
    if sidebar.offset().left >= 0
      hideSidebar()
    else
      showSidebar()

  $('#search_form').submit ->
    return true unless map? and sidebar.length > 0

    # TODO Add sidebar loading
    # TODO Pushstate

    center = map.map.getCenter()

    $.get "/search?#{$('#search_form').serialize()}&lat=#{center.lat}&lng=#{center.lng}", (data) ->
      $('#sidebar').html(data)
      map.updateSearchResults()
      updateSidebar()
      showSidebar()

    false # Don't send form in normal way

  updateSidebar()

