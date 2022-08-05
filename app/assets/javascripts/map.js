var map, tiles;
$(function() {
    if($('#map').length > 0) {
        map = L.map('map', {scrollWheelZoom: false}).setView([49.249935,-123.112457],11);
        //1c76eefca5954c5abfa169b96dc96a35
        L.Icon.Default.imagePath = '/assets/';
        L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '', detectRetina: true
        }).addTo(map);

        var markers = new L.MarkerClusterGroup();
        var bounds = new L.LatLngBounds();

        //for(var i = 0; i < categories.length; i++) {
        var locations = window.locations;//categories[i]['locations'];
        for(var x = 0; x < locations.length; x++) {
            var location = locations[x];

            if(location['latitude'] && location['longitude']) {
                var title = location['name'];
                var pt = new L.LatLng(location['latitude'], location['longitude']);
                var myIcon = L.icon({
                  iconUrl: '/assets/leaf-red.png',
                  iconSize: [25, 41],
                  iconAnchor: [12, 41],
                  popupAnchor: [-3, -40],
                  shadowUrl: '',
                  shadowSize: [68, 95],
                  shadowAnchor: [12, 41]
                });
                var options = { title: title }
                if (location['not_business']) {
                  options['icon'] = myIcon
                }
                var marker = new L.Marker(pt, options);
                var markerPopup = ""
                if (!location['url']) {
                  markerPopup = (location['thumb'] ? "<div>" + "<img src='" + location['thumb'] + "' width='157' />" + "</div>" : "" ) + "<div style='margin-top:5px;margin-bottom:5px;'>" + title + "</div>"
                } else {
                  markerPopup = (location['thumb'] ? "<a href='" + location['url'] + "'>" + "<img src='" + location['thumb'] + "' width='157' />" + "</a>" : "" ) + "<div style='margin-top:5px;margin-bottom:5px;'><a href='" + location['url'] + "'>" + title + "</a></div>"
                }
                marker.bindPopup(markerPopup);
                markers.addLayer(marker);
                bounds.extend(pt);
            }
        }

        map.addLayer(markers);

        if(Object.keys(bounds).length > 0) {
            map.fitBounds(bounds);
        }
    }

    if($('#profile-map').length > 0) {
        Window.helpers.initMap($('#profile-map')[0]);
    }
});
