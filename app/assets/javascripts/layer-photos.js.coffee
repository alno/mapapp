

class @Photo

  constructor: (@data) ->
    @point = new L.LatLng(@data.lat, @data.lng)

  getMarker: ->
    return @marker if @marker

    markerOptions = {}
    markerOptions.icon = app.buildIcon('/images/icons-classic/photo.png')

    popupContent = $("<div><a href=\"http://www.panoramio.com/\" target=\"_blank\"><img src=\"http://www.panoramio.com/img/logo-small.gif\" /></a><br /><br /><a href=\"#{@data.url}\" target=\"_blank\"><img src=\"#{@data.image_url}\" /></a><br /><b><a href=\"#{@data.url}\" target=\"_blank\">#{@data.title}</a></b><br />by <a href=\"#{@data.author_url}\" target=\"_blank\">#{@data.author_name}</a></div>")

    @marker = new L.Marker(@point, markerOptions)
    @marker.bindPopup popupContent[0]
    @marker

class @PhotoLayer

  constructor: ->
    @group = new L.LayerGroup()
    @photos = {}
    @limitedUpdate = L.Util.limitExecByInterval(@update, 2000, @);

  onAdd: (map) ->
    @map = map

    map.addLayer(@group)
    map.on('move', @limitedUpdate, @)
    map.on('moveend', @update, @)
    map.on('viewreset', @update, @)

    @update()

  onRemove: (map) ->
    map.off('viewreset', @update, @)
    map.off('moveend', @update, @)
    map.off('move', @limitedUpdate, @)
    map.removeLayer(@group)

    @map = undefined

  update: ->
    $.get "/photos.json?bbox=#{@map.getBounds().toBBoxString()}", (photosData) =>
      newPhotos = {}

      for data in photosData
        id = data.id

        if @photos[id]
          newPhotos[id] = @photos[id]
          @photos[id] = undefined
        else
          newPhotos[id] = new Photo(data)

      for id, photo of @photos when photo
        @group.removeLayer(photo.getMarker())

      for id, photo of newPhotos
        @group.addLayer(photo.getMarker())

      @photos = newPhotos
