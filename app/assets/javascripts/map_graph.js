var mapgraph_mapLoaded = false;
var mapgraph_barLoaded = false;

function setState(st){
  console.log('setState: ' + st);
  window.sendToGraph(OurvoyceApp.details.current_details() + "/age/" + st);
}

window.sendToMap = function(dataString) {
  console.log('sendToMap: ' + dataString);
  window.thisMovie("map").sendTextToFlash(dataString);
}

window.sendToGraph = function(dataString) {
  console.log('sendToGraph: ' + dataString);
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
  console.log('mapEmbedded');
  mapgraph_mapLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

window.barEmbedded = function(e){
  console.log('barEmbedded');
  mapgraph_barLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

//window.mapgraph_mapvars = {
window.mapgraph_mapvars = function(){
  return {
    xmlpath: OurvoyceApp.details.current_details() + "/map/",
    baseURL: "/items/"
  };
}

window.mapgraph_agevars = function(){
  return {
    xmlpath: OurvoyceApp.details.current_details() + "/age/",
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
    //swfobject.embedSWF("/swf/map.swf", "map", "350", "270","10.0.0", "", mapgraph_mapvars(), mapgraph_params, mapgraph_attributes, barEmbedded);
    //swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "350", "240","10.0.0", "", mapgraph_agevars(), mapgraph_params, mapgraph_attributes, mapEmbedded);     
    swfobject.embedSWF("/swf/map.swf", "map", "320", "246","10.0.0", "", window.mapgraph_mapvars(), mapgraph_params, mapgraph_attributes, window.mapEmbedded);
    swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "320", "150","10.0.0", "", window.mapgraph_agevars(), mapgraph_params, mapgraph_attributes, window.barEmbedded);     
  }

});
