//var mapgraph_state = "";
//var model = '<%= model %>';
//var curID = "<%= id %>";
//window.curID = '';
var mapgraph_mapLoaded = false;
var mapgraph_barLoaded = false;

function setState(st){
  //mapgraph_state = st;
  window.sendToGraph("/age/" + st);
  //url = "/items/" + curID + "/graph/age/" + mapgraph_state;
  //alert(url);
  //sendToGraph(url);
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

//$(document).ready(function(){
//function getFlashMovie(movieName) { 
//var isIE = navigator.appName.indexOf("Microsoft") != -1;
//return (isIE) ? window[movieName] : document[movieName];
//}


//$("a.dataset").click(function(){

//var tableParent = $(this).parent().parent().parent().parent();

//if(tableParent.hasClass("singlet-table")){
//$(".singlet.selected").removeClass("selected");
//$(".vote-table .selected").removeClass("selected");  //remove the selected items
//tableParent.parent().parent().addClass("selected");  //add the selected class to the singlet
//}else{
//$(".singlet.selected").removeClass("selected");
//$(".vote-table .selected").removeClass("selected");  //remove the selected items
//$(this).parent().parent().addClass("selected");  //add selected to the clicked item
//}

//map_data = $(this).children('.jq-map-data').val();

//curID = map_data.split('_')[0];
//model = map_data.split('_')[1]

//sendToMap(model + "/map/" + curID + "/");  //send to the map
//sendToMap("/map/" + curID + "/");  //send to the map
//sendToGraph(model + "/age/" + curID + "/" + mapgraph_state);  //send to the graph
//sendToGraph("/age/" + curID + "/" + mapgraph_state);  //send to the graph

//return false;
//});

//$('.jq-corporation').live('click', function(){
//$id = $(this).children('.jq-corporation-id').val();
//alert('here');
//$url = "/services/website/corporate/" + $id + "/all";
//$.ajax({
//url: $url,
//dataType: 'xml',
//success: function(data){
//$('.jq-map').html("<textarea rows='50' cols='50'>" + (new XMLSerializer()).serializeToString(data) + "</textarea>");
//}
//});
//});

//});


var mapEmbedded = function(e){
  mapgraph_mapLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

var barEmbedded = function(e){
  mapgraph_barLoaded = true;

  if(mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

  //window.mapgraph_mapvars = {
  function mapgraph_mapvars(){
    return {
      xmlpath: OurvoyceApp.details.current_details() + "/map",
      baseURL: "/items/"
    };
  }

  function mapgraph_agevars(){
    return {
      xmlpath: OurvoyceApp.details.current_details() + "/age",
      baseURL:"/items/",
      barwidth: 25
    };
  }

$(function(){
  var mapgraph_params = {
    menu: "false",
    wmode: "transparent"
  };

  var mapgraph_attributes = {
    allowfullscreen: "true",
  allowscriptaccess: "always",
  wmode: "transparent"
  };

  window.createSWFObjects = function(){
    //swfobject.embedSWF("/swf/map.swf", "map", "350", "270","10.0.0", "", mapgraph_mapvars(), mapgraph_params, mapgraph_attributes, barEmbedded);
    //swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "350", "240","10.0.0", "", mapgraph_agevars(), mapgraph_params, mapgraph_attributes, mapEmbedded);     
    swfobject.embedSWF("/swf/map.swf", "map", "320", "246","10.0.0", "", mapgraph_mapvars(), mapgraph_params, mapgraph_attributes, barEmbedded);
    swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "320", "220","10.0.0", "", mapgraph_agevars(), mapgraph_params, mapgraph_attributes, mapEmbedded);     
  }

});
