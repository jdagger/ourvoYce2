window.barLoaded = false
window.mapLoaded = false
window.mapState = ''

window.setState = (st) ->
  #Try to remove coupling to details
  window.mapState = st
  window.sendToGraph(OurvoyceApp.detail.id())
  window.sendToMap(OurvoyceApp.detail.id())
  return

window.sendToMap = (id) ->
  dataString = "#{id}/map/"
  window.thisMovie("map").sendTextToFlash(dataString)
  return

window.sendToGraph = (id) ->
  dataString = "#{id}/age/#{window.mapState}"
  window.thisMovie("bar-graph").sendTextToFlash(dataString)
  return

window.thisMovie = (movieName) ->
  if navigator.appName.indexOf("Microsoft") != -1
    return window[movieName]
  else
    return document[movieName]


window.barEmbedded = (e) ->
  window.barLoaded = true
  return

window.mapEmbedded = (e) ->
  window.mapLoaded = true
  return

window.initializeMaps = () ->
	mapvars =
    baseURL: "/items/"

  params =
    menu: "false",
    wmode: "transparent"

  attributes =
    allowfullscreen: "true",
    allowscriptaccess: "always",
    wmode: "transparent"

	agevars =
    baseURL: "/items/",
    barwidth: "25"

  swfobject.switchOffAutoHideShow()
  swfobject.embedSWF("/swf/map.swf", "map", "300", "231","10.0.0", "", mapvars, params, attributes, window.barEmbedded)
  swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "300", "188","10.0.0", "", agevars, params, attributes, window.mapEmbedded)
  return
