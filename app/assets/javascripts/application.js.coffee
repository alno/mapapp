#= require jquery
#= require jquery_ujs

#= require bootstrap-modal
#= require bootstrap-tab

#= require i18n
#= require i18n/translations

#= require_tree .

$ ->
  window.app = new App()

  $('#sidebar_toggle').click ->
    if app.sidebar.offset().left >= 0
      app.hideSidebar()
    else
      app.showSidebar()

  $('#search_form').submit ->
    # TODO Add sidebar loading
    # TODO Pushstate

    center = app.map.getCenter()

    $.get "/search?#{$('#search_form').serialize()}&lat=#{center.lat}&lng=#{center.lng}", (data) ->
      app.updateSearchResults(data)

    false # Don't send form in normal way

  $('#sidebar .close').click ->
    app.hideSidebar()
    false

  $('#sidebar_handle a').click ->
    app.showSidebar()
    true
