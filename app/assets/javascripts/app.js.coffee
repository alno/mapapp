class @App

  constructor: ->
    @sidebar = $('#sidebar')
    @content = $('#content')

    $('#map').each =>
      @map = new L.Map('map')
      @map.addControl(new L.Control.Distance())
      @map.addLayer(Layers.base)
      @map.setView(new L.LatLng(54.5302,36.2597,1), 12)

      @map.on 'dblclick', (e) =>
        @map.addLayer(new L.Marker(e.latlng))

  showSidebar: ->
    if @sidebar.offset().left < 0
      @content.addClass('with-sidebar')
      @sidebar.animate({left: 0}, 200)

  hideSidebar: ->
    if @sidebar.offset().left >= 0
      @content.removeClass('with-sidebar')
      @sidebar.animate({left: -400}, 200)

  updateSearchResults: (data)->
    if @searchResultsLayer
      @map.removeLayer(@searchResultsLayer)
      @searchResultsLayer = null

    if data
      @sidebar.find('.query').text(data.query)
      @sidebar.find('.results').html('')
      @sidebar.find('.pagination').html('')

      if data.results.length == 0
        @sidebar.find('.results').text('Nothing found =(')
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
      @sidebar.html('Nothing to search')

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

    appendLink(1) if current - size > 1
    appendGap() if current - size > 2

    if current > 1
      appendLink(page) for page in [Math.max(current-size,1)..current-1]

    appendActive(current)

    if current < count
      appendLink(page) for page in [current+1..Math.min(current+size,count)]

    appendGap() if current + size < count - 1
    appendLink(count) if current + size < count

  buildResult: (result) ->
    zoom = 14
    point = new L.LatLng(result.lat, result.lng)
    marker = new L.Marker(point)
    marker.bindPopup("<h3>#{result.name}</h3><b>#{result.address}</b>")
    @searchResultsLayer.addLayer(marker)

    li = $('<li class="search-result">')
    li.append($("<a class=\"name\" href=\"#\">#{result.name}</a>").click =>
      @map.panTo(point)
      @map.setZoom(zoom)
      marker.openPopup()
    )
    li.append($("<span class=\"address\">#{result.address}</span>")) if result.address
    li
