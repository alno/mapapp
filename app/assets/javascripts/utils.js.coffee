
@App.Utils =

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

    return if count <= 1

    appendLink(1) if current - size > 1
    appendGap() if current - size > 2

    if current > 1
      appendLink(page) for page in [Math.max(current-size,1)..current-1]

    appendActive(current)

    if current < count
      appendLink(page) for page in [current+1..Math.min(current+size,count)]

    appendGap() if current + size < count - 1
    appendLink(count) if current + size < count

  buildIcon: (url) ->
    @iconCache = {} unless @iconCache
    return @iconCache[url] if @iconCache[url]

    iconClass = L.Icon.extend
      options:
        iconUrl: url
        iconSize: new L.Point(32, 37)
        iconAnchor: new L.Point(16, 35)
        shadowUrl: '/images/marker-shadow.png'
        shadowSize: new L.Point(50, 35)
        popupAnchor: new L.Point(0, -25)

    @iconCache[url] = new iconClass()
