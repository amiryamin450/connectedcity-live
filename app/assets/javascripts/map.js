var map, tiles;
$(function() {
    if($('#map').length > 0) {
        map = L.map('map', {scrollWheelZoom: false}).setView([49.249935,-123.112457],9);
        //1c76eefca5954c5abfa169b96dc96a35
        L.Icon.Default.imagePath = '/assets/';
        L.tileLayer('//{s}.tiles.mapbox.com/v3/grt777.j18k947c/{z}/{x}/{y}.png', {
            attribution: '', detectRetina: true
        }).addTo(map);

        var markers = new L.MarkerClusterGroup();
        var bounds = new L.LatLngBounds();

        //for(var i = 0; i < categories.length; i++) {
        //console.log("category name - " + $categories[$i]['name'] );
        var locations = window.locations;//categories[i]['locations'];
        for(var x = 0; x < locations.length; x++) {
            var location = locations[x];

            if(location['latitude'] && location['longitude']) {
                var title = location['name'];
                var pt = new L.LatLng(location['latitude'], location['longitude']);
                var marker = new L.Marker(pt, { title: title });
                marker.bindPopup((location['thumb'] ? "<img src='" + location['thumb'] + "' width='157' />" : "" ) + "<div style='margin-top:5px;margin-bottom:5px;'><a href='" + location['url'] + "'>" + title + "</a></div>");
                markers.addLayer(marker);
                bounds.extend(pt);
            }
        }

        console.log(markers);
        map.addLayer(markers);

        if(Object.keys(bounds).length > 0) {
            map.fitBounds(bounds);
        }
    }

    if($('#profile-map').length > 0) {

        map = L.map('profile-map', {scrollWheelZoom: false}).setView([49.249935,-123.112457],12);
        L.Icon.Default.imagePath = '/assets/';
        //1c76eefca5954c5abfa169b96dc96a35
        tiles = L.tileLayer('//{s}.tiles.mapbox.com/v3/grt777.j18k947c/{z}/{x}/{y}.png', {
            attribution: '',
            maxZoom: 18
        })
        tiles.addTo(map);

        var loc = Window.profile_marker;
        console.log(loc);

        var pt = new L.LatLng(loc['lat'], loc['long']);
        var marker = new L.Marker(pt);
        map.addLayer(marker);
        map.setView(pt, 16, true);

        $('#map-tab').click(function(){
           map.invalidateSize(false);

            // var loc = Window.profile_marker;
            // var pt = new L.LatLng(loc['lat'], loc['long']);
            // map.setView(pt, 16, true);
            // tiles.redraw();
        });

    }
});
