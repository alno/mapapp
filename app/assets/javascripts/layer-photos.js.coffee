

class @Photo

  constructor: (@data) ->
    @point = new L.LatLng(@data.lat, @data.lng)

  getMarker: ->
    return @marker if @marker

    markerOptions = {}
    markerOptions.icon = app.buildIcon('/images/icons-classic/photo.png')

    @marker = new L.Marker(@point, markerOptions)
    @marker.bindPopup @data.popup
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

  getAttribution: ->
    'Photos provided by <a href="http://panoramio.com/">Panoramio</a>. Photos are under the copyright of their owners.'

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
