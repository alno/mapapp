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
#= require leaflet.scale

#= require app

$ ->
  window.app = new App()

  $('#sidebar_toggle').click ->
    if app.sidebar.offset().left >= 0
      app.hideSidebar()
    else
      app.showSidebar()

  $('#search_form').submit ->
    app.navigate
      mode: 'search'
      query: $('#search_form .search-query').val()
    false

  $('#sidebar .close').click ->
    app.hideSidebar()
    false

  $('#sidebar_handle a').click ->
    app.showSidebar()
    true

  $('#style_switch button').click ->
    $(@).button('toggle')
    app.selectStyle($(@).data('style'))

  $('#style_switch button').first().click()

  $('#layer_checks button').click ->
    layer = app.layers[$(@).data('layer')]

    if $(@).hasClass('active')
      app.map.removeLayer(layer)
    else
      app.map.addLayer(layer)
