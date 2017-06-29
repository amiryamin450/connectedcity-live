Window.helpers =
  initMap: (el)->
    map = L.map(el, scrollWheelZoom: false).setView([49.249935, -123.112457], 12)
    L.Icon.Default.imagePath = '/assets/'
    tiles = L.tileLayer('//{s}.tiles.mapbox.com/v3/grt777.j18k947c/{z}/{x}/{y}.png',
      attribution: ''
      maxZoom: 18)
    tiles.addTo map
    if $(el).data("coordinates")
      loc = $(el).data("coordinates")
    else
      loc = Window.profile_marker
    pt = new (L.LatLng)(loc['lat'], loc['long'])
    marker = new (L.Marker)(pt)
    map.addLayer marker
    map.setView pt, 16, true
