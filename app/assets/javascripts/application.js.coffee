#= require jquery
#= require jquery_ujs

#= require underscore

#= require bootstrap-modal
#= require bootstrap-tab
#= require bootstrap-button

#= require i18n
#= require i18n/translations

#= require leaflet-src

#= require_tree .

$ ->
  window.app = new App()

  $('#sidebar_toggle').click ->
    if app.sidebar.offset().left >= 0
      app.hideSidebar()
    else
      app.showSidebar()

  $('#search_form').submit ->
    center = app.map.getCenter()
    app.navigate("search/#{center.lat}/#{center.lng}/#{$('#search_form .search-query').val()}")
    false

  $('#sidebar .close').click ->
    app.hideSidebar()
    false

  $('#sidebar_handle a').click ->
    app.showSidebar()
    true
