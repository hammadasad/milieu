// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

var Map = {};
Map.nearby_marker_img = "http://maps.google.com/mapfiles/ms/icons/yellow-dot.png"

mapStyle = [{"featureType":"water","elementType":"geometry","stylers":[{"color":"#004358"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#1f8a70"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#1f8a70"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#fd7400"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-20}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-17}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"visibility":"on"},{"weight":0.9}]},{"elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-10}]},{},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"weight":0.7}]}];


function addMarkers(coords) {

    coords.forEach (function(coords) {
        var myMarker = new google.maps.Marker({
            position: new google.maps.LatLng(coords.latitude, coords.longitude),
            map: Map.canvas,
            icon: Map.nearby_marker_img
        });
    });

};

function initializeMap() {
    // initialize with map options
    Map.options = {
        zoom: 14 ,
        center: new google.maps.LatLng(Map.latitude, Map.longitude),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    Map.canvas = new google.maps.Map($('#map-canvas')[0], Map.options);
    Map.canvas.setOptions({styles: mapStyle});

    if (Map.showMarkers) {
        var myMarker = new google.maps.Marker({
            position: new google.maps.LatLng(Map.latitude, Map.longitude),
            map: Map.canvas
        });
    };

};

function geolocationSuccess(position) {
  var latitude = position.coords.latitude;
  var longitude = position.coords.longitude;

  // Make ajax call if successful
  $('#location-error').hide();
  $.ajax({
      url: '/sites',
      type: 'GET',
      dataType: 'script',
      data: {
        latitude: latitude,
        longitude: longitude
      }
    });
};

function geolocationError() {
  var $locationError = $('<p>Unable to find your location</p>');
  $locationError.addClass('location-error');
  $('#current-location').after($locationError);
};

function hashMap() {
    //Local variables
    var map = {};    

    //Methods
    this.puts = function(key, value) {
        map[key] = value;
    }
    this.gets = function(key) {
        return map[key];
    }
    this.exists = function(key) {
        return key in map; 
    }
    this.getMap = function() {
        return map;
    }    

    return this;
}

//  function processData(aCsv) {
//     var data = Papa.parse(aCsv);
//     var listOfEntries = data.data;
//     console.log(listOfEntries);
//     var csvTitles = listOfEntries[0];
//     var dataSet = [];
//     var listofAddresses = [];
//     for(var x = 1 ; x <= 20; x++ ) {
//         dataSet.push(listOfEntries[x]);
//         var anAddress = listOfEntries[x][5] + " " + listOfEntries[x][6] + " " + listOfEntries[x][7] + ",Toronto";
//         console.log(anAddress);
//         var isContains = $.inArray(anAddress, listofAddresses);
//         if(isContains === -1) {
//             addressToLatLng(anAddress);
//             listofAddresses.push(anAddress);
//         }
//     }

//     console.log(dataSet);
//     console.log(dataSet[0]);
// }


$(document).on('ready page:load',function() {
  // Search
  $("#search-input").focus(function() {
    $(this).attr("placeholder", "");
  }).blur(function() {
    $(this).attr("placeholder", "Find a site ...");
  });

  $('#current-location').on('click', function(ev) {
    ev.preventDefault();

    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError);
    } else {
      alert("Get a better browser, can't use geolocation!");
    };
  });

  if ($('#map-canvas').length){
      initializeMap();
      if (Map.coords.length > 0) addMarkers(Map.coords);
  } 

  // //Get CSV from local directory
  // $.get("assets/activepermits2.csv", function(data) {
  //     console.log("CSV file found");
  //     data = processData(data);
  // });

});