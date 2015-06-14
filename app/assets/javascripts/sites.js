// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

var Map = {};
Map.nearby_marker_img = "http://maps.google.com/mapfiles/ms/icons/yellow-dot.png"

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

});