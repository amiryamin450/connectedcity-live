$(document).ready(function() {
  $('#province-dropdown').on('change', function(event) {
    var provinceId = event.target.value
    $.ajax({
      url: `/home/get_regions?province_id=${provinceId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetRegions();
      resetMunicipalities();
      resetCities();
      $.each(response, function(index, region) {
        $('#region-dropdown').append($('<option>', {
            value: region.id,
            text: region.name
        }));
      })
    });
  })

  $('#region-dropdown').on('change', function(event) {
    var regionId = event.target.value
    $.ajax({
      url: `/home/get_municipalities?region_id=${regionId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetMunicipalities();
      resetCities();
      $.each(response, function(index, municipality) {
        $('#municipality-dropdown').append($('<option>', {
            value: municipality.id,
            text: municipality.name
        }));
      })
    });
  })

  $('#municipality-dropdown').on('change', function(event) {
    var municipalityId = event.target.value
    $.ajax({
      url: `/home/get_cities?municipality_id=${municipalityId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetCities();
      $.each(response, function(index, city) {
        $('#city-dropdown').append($('<option>', {
            value: city.id,
            text: city.csdname
        }));
      })
    });
  })

  $('#city-dropdown').on('change', function(event) {
    var cityId = event.target.value
    $('#city-landing-path').attr("href", `/home/city_landing/${cityId}`)
  })

  function resetRegions() {
    $('#region-dropdown').find('option').remove();
    $('#region-dropdown').append($('<option>', {
      text: "Region"
    }));
  }

  function resetMunicipalities() {
    $('#municipality-dropdown').find('option').remove();
    $('#municipality-dropdown').append($('<option>', {
      text: "Municipality/County"
    }));
  }

  function resetCities() {
    $('#city-dropdown').find('option').remove();
    $('#city-dropdown').append($('<option>', {
      text: "City/Town"
    }));
  }
})