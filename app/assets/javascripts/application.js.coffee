#= require jquery
#= require jquery_ujs

#= require underscore

#= require bootstrap-modal
#= require bootstrap-tab
#= require bootstrap-button
#= require bootstrap-dropdown

#= require i18n
#= require i18n/translations

#= require leaflet-src

#= require app

$ ->
  window.app = new App()

  $('#sidebar_toggle').click ->
    if app.sidebar.offset().left >= 0
      app.hideSidebar()
    else
      app.showSidebar()

  $('#mode_search').submit ->
    center = app.map.getCenter()
    app.navigate("search/#{center.lat}/#{center.lng}/#{$('#mode_search .search-query').val()}")
    false

  $('#sidebar .close').click ->
    app.hideSidebar()
    false

  $('#sidebar_handle a').click ->
    app.showSidebar()
    true
