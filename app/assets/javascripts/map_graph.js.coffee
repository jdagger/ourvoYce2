window.setState = (st) ->
  console.log "setState(#{st})"
  window.sendToGraph(OurvoyceApp.details.current_item().get('id'), st)
  return

window.sendToMap = (id) ->
  console.log "sendToMap(#{id})"
  dataString = "#{id}/map/"
  window.thisMovie("map").sendTextToFlash(dataString)
  return

window.sendToGraph = (id, st) ->
  console.log("sendToGraph(#{id}, #{st}")
  dataString = "#{id}/age/#{st}"
  window.thisMovie("bar-graph").sendTextToFlash(dataString)
  return

window.thisMovie = (movieName) ->
  console.log("this.movie(#{movieName})")
  if navigator.appName.indexOf("Microsoft") != -1
    return window[movieName]
  else
    return document[movieName]
