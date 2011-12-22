window.barLoaded = false
window.mapLoaded = false
window.mapState = ''

window.setState = (st) ->
  #Try to remove coupling to details
  window.mapState = st
  window.sendToGraph(OurvoyceApp.detail.id())
  return

window.sendToMap = (id) ->
  console.log 'sendToMap'
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
  
  #if mapLoaded && barLoaded
  return

window.mapEmbedded = (e) ->
  window.mapLoaded = true
  #if( mapLoaded && barLoaded)
  
  return

$(() ->
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
  swfobject.embedSWF("/swf/map.swf", "map", "320", "247","10.0.0", "", mapvars, params, attributes, window.barEmbedded)
  swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "320", "200","10.0.0", "", agevars, params, attributes, window.mapEmbedded)
  return
)
