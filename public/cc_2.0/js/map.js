(function() {
  Window.helpers = {
    initMap: function(el) {
      var loc, map, marker, pt, tiles;
      map = L.map(el, {
        scrollWheelZoom: false
      }).setView([49.249935, -123.112457], 12);
      L.Icon.Default.imagePath = '/assets/';
      tiles = L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '',
        maxZoom: 18
      });
      tiles.addTo(map);
      if ($(el).data("coordinates")) {
        loc = $(el).data("coordinates");
      } else {
        loc = Window.profile_marker;
      }
      if (loc['lat'] !== null && loc['long'] !== null) {
        pt = new L.LatLng(loc['lat'], loc['long']);
        marker = new L.Marker(pt);
        map.addLayer(marker);
        return map.setView(pt, 16, true);
      }
    },
    initJScroll: function(el) {
      return $(el).jscroll();
    }
  };
  
}).call(this);

$(document).on("click", ".status-update-image img, .status-update-image", function(){
  setTimeout(function(){
    if ($('.profile-map:visible').length){
      Window.helpers.initMap($('.profile-map:visible')[0]);
    }
  }, 500);
});