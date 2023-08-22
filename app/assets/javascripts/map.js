var map, tiles;
function showMap(el) {
  if ($("#" + el).length > 0) {
    map = L.map(el, { scrollWheelZoom: false }).setView(
      [49.249935, -123.112457],
      11
    );
    //1c76eefca5954c5abfa169b96dc96a35
    L.Icon.Default.imagePath = "/assets/";
    L.tileLayer("//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "",
      detectRetina: true,
    }).addTo(map);

    var markers = new L.MarkerClusterGroup();
    var bounds = new L.LatLngBounds();

    //for(var i = 0; i < categories.length; i++) {
    var locations = window.locations; //categories[i]['locations'];
    for (var x = 0; x < locations.length; x++) {
      var location = locations[x];

      if (location["latitude"] && location["longitude"]) {
        var title = location["name"];
        var pt = new L.LatLng(location["latitude"], location["longitude"]);
        var myIcon = L.icon({
          iconUrl: "/assets/leaf-red.png",
          iconSize: [25, 41],
          iconAnchor: [12, 41],
          popupAnchor: [-3, -40],
          shadowUrl: "",
          shadowSize: [68, 95],
          shadowAnchor: [12, 41],
        });
        var options = { title: title };
        if (location["not_business"]) {
          options["icon"] = myIcon;
        }
        var marker = new L.Marker(pt, options);
        var markerPopup = "";

        switch (location["type"]) {
          case "status_update":
            markerPopup =
              (location["thumb"]
                ? "<div>" +
                  "<a href='#' class='status-update-image' data-target='#status-" +
                  location["id"] +
                  "-model' data-toggle='modal'><img src='" +
                  location["thumb"] +
                  "' width='157' /></a></div>"
                : "") +
              "<div style='margin-top:5px;margin-bottom:5px;'><a href='#' class='status-update-image' data-target='#status-" +
              location["id"] +
              "-model' data-toggle='modal'>" +
              title +
              "</a></div>";
            break;
          case "news_article":
            markerPopup =
              (location["thumb"]
                ? "<a href='#' class='status-update-image' data-target='#news-" +
                  location["id"] +
                  "-model' data-toggle='modal'><img src='" +
                  location["thumb"] +
                  "' width='157' />" +
                  "</a>"
                : "") +
              "<div style='margin-top:5px;margin-bottom:5px;'><a href='#' class='status-update-image' data-target='#news-" +
              location["id"] +
              "-model' data-toggle='modal'>" +
              title +
              "</a></div>";
            break;
          case "event":
            markerPopup =
              (location["thumb"]
                ? "<a href='#' class='status-update-image' data-target='#event-" +
                  location["id"] +
                  "-model' data-toggle='modal'><img src='" +
                  location["thumb"] +
                  "' width='157' />" +
                  "</a>"
                : "") +
              "<div style='margin-top:5px;margin-bottom:5px;'><a href='#' class='status-update-image' data-target='#event-" +
              location["id"] +
              "-model' data-toggle='modal'>" +
              title +
              "</a></div>";
            break;
          case "media_attachment":
            markerPopup =
              (location["thumb"]
                ? "<a href='#' class='status-update-image' data-target='#video-" +
                  location["id"] +
                  "-model' data-toggle='modal'><img src='" +
                  location["thumb"] +
                  "' width='157' />" +
                  "</a>"
                : "") +
              "<div style='margin-top:5px;margin-bottom:5px;'><a href='#' class='status-update-image' data-target='#video-" +
              location["id"] +
              "-model' data-toggle='modal'>" +
              title +
              "</a></div>";
            break;
          default:
            markerPopup =
              (location["thumb"]
                ? "<a href='" +
                  location["url"] +
                  "'>" +
                  "<img src='" +
                  location["thumb"] +
                  "' width='157' />" +
                  "</a>"
                : "") +
              "<div style='margin-top:5px;margin-bottom:5px;'><a href='" +
              location["url"] +
              "'>" +
              title +
              "</a></div>";
        }
        marker.bindPopup(markerPopup);
        markers.addLayer(marker);
        bounds.extend(pt);
      }
    }

    map.addLayer(markers);

    if (Object.keys(bounds).length > 0) {
      map.fitBounds(bounds);
    }
  }

  if ($("#profile-map").length > 0) {
    Window.helpers.initMap($("#profile-map")[0]);
  }
}

$(document).ready(function () {
  if ($("#map").is(":visible") > 0) {
    showMap("map");
  }

  if ($("#map-mobile").is(":visible") > 0) {
    showMap("map-mobile");
  }
});
