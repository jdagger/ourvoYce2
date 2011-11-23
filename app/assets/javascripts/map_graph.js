var mapgraph_mapLoaded = false;
var mapgraph_barLoaded = false;

function setState(st){
  window.sendToGraph(OurvoyceApp.details.current_item().get('id') + "/age/" + st);
}

window.sendToMap = function(dataString) {
  window.thisMovie("map").sendTextToFlash(dataString);
}

window.sendToGraph = function(dataString) {
  window.thisMovie("bar-graph").sendTextToFlash(dataString);
}

window.thisMovie = function(movieName) {
  if (navigator.appName.indexOf("Microsoft") != -1) {
    return window[movieName];
  } else {
    return document[movieName];
  }
}

window.mapEmbedded = function(e){
  mapgraph_mapLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

window.barEmbedded = function(e){
  mapgraph_barLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

//window.mapgraph_mapvars = {
window.mapgraph_mapvars = function(){
  return {
    xmlpath: OurvoyceApp.details.current_item_id() + "/map/",
    baseURL: "/items/"
  };
}

window.mapgraph_agevars = function(){
  return {
    xmlpath: OurvoyceApp.details.current_item_id() + "/age/",
    baseURL:"/items/",
    barwidth: 25
  };
}

var mapgraph_params = {
  menu: "false",
  wmode: "transparent"
};

var mapgraph_attributes = {
  allowfullscreen: "true",
  allowscriptaccess: "always",
  wmode: "transparent"
};

$(function(){
  window.createSWFObjects = function(){
    swfobject.embedSWF("/swf/map.swf", "map", "320", "246","10.0.0", "", window.mapgraph_mapvars(), mapgraph_params, mapgraph_attributes, window.mapEmbedded);
    swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "320", "150","10.0.0", "", window.mapgraph_agevars(), mapgraph_params, mapgraph_attributes, window.barEmbedded);     
  }

});
