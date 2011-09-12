var mapgraph_state = "";
//var model = '<%= model %>';
//var curID = "<%= id %>";
var curID = '';
var mapgraph_mapLoaded = false;
var mapgraph_barLoaded = false;

function setState(st){
  mapgraph_state = st;
  //sendToGraph(model + "/age/" + curID + "/" + mapgraph_state);
  url = "/items/" + curID + "/graph/age/" + mapgraph_state;
  alert(url);
  sendToGraph(url);
}

window.sendToMap = function(dataString) {
  thisMovie("map").sendTextToFlash(dataString);
}

window.sendToGraph = function(dataString) {
  thisMovie("bar-graph").sendTextToFlash(dataString);
}

window.thisMovie = function(movieName) {
  if (navigator.appName.indexOf("Microsoft") != -1) {
    return window[movieName];
  } else {
    return document[movieName];
  }
}

$(document).ready(function(){
  function getFlashMovie(movieName) { 
    var isIE = navigator.appName.indexOf("Microsoft") != -1;
    return (isIE) ? window[movieName] : document[movieName];
  }


  $("a.dataset").click(function(){

    //createSWFObjects();

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

    map_data = $(this).children('.jq-map-data').val();

    curID = map_data.split('_')[0];
    //model = map_data.split('_')[1]

    //sendToMap(model + "/map/" + curID + "/");  //send to the map
    sendToMap("/map/" + curID + "/");  //send to the map
    //sendToGraph(model + "/age/" + curID + "/" + mapgraph_state);  //send to the graph
    sendToGraph("/age/" + curID + "/" + mapgraph_state);  //send to the graph

    return false;
  });

  $('.jq-corporation').live('click', function(){
    $id = $(this).children('.jq-corporation-id').val();
    alert('here');
    $url = "/services/website/corporate/" + $id + "/all";
    $.ajax({
      url: $url,
      dataType: 'xml',
      success: function(data){
        $('.jq-map').html("<textarea rows='50' cols='50'>" + (new XMLSerializer()).serializeToString(data) + "</textarea>");
      }
    });
  });

});


function mapEmbedded(e){
  mapgraph_mapLoaded = true;

  if( mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

function barEmbedded(e){
  mapgraph_barLoaded = true;

  if( mapgraph_mapLoaded && mapgraph_barLoaded){
  }
}

//var mapgraph_mapvars = {
  ////xmlpath: model + "/map/" + curID + "/",
  //xmlpath: curID + "/map/",
  ////baseURL:"/services/website/"
  //baseURL: "/items/"
//};


//var mapgraph_agevars = {
  ////xmlpath: model + "/age/" + curID + "/",
  //xmlpath: curID + "/graphs/age/",
  ////baseURL:"/services/website/",
  //baseURL:"/items/",
  //barwidth: 25
//};

//var mapgraph_params = {
  //menu: "false",
  //wmode: "transparent"
//};

//var mapgraph_attributes = {
  //allowfullscreen: "true",
  //allowscriptaccess: "always",
  //wmode: "transparent"
//};

var createSWFObjects = function(){
  //swfobject.embedSWF("/swf/map.swf", "map", "350", "270","10.0.0", "", mapgraph_mapvars, mapgraph_params, mapgraph_attributes, barEmbedded);
  //swfobject.embedSWF("/swf/bar-graph.swf", "bar-graph", "350", "240","10.0.0", "", mapgraph_agevars, mapgraph_params, mapgraph_attributes, mapEmbedded);     
}
