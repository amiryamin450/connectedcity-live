$(document).ready(function() {
  $('#province-dropdown').on('change', function(event) {
    let provinceId = event.target.value
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
            value: region.slug,
            text: region.name
        }));
      })
    });
  })

  $('#region-dropdown').on('change', function(event) {
    let regionId = event.target.value
    $.ajax({
      url: `/home/get_municipalities?region_id=${regionId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetMunicipalities();
      resetCities();
      $.each(response, function(index, municipality) {
        $('#municipality-dropdown').append($('<option>', {
            value: municipality.slug,
            text: municipality.name
        }));
      })
    });
  })

  $('#municipality-dropdown').on('change', function(event) {
    let municipalityId = event.target.value
    $.ajax({
      url: `/home/get_cities?municipality_id=${municipalityId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetCities();
      $.each(response, function(index, city) {
        $('#city-dropdown').append($('<option>', {
            value: city.slug,
            text: city.csdname
        }));
      })
    });
  })

  $('#city-dropdown').on('change', function(event) {
    let province = $('#province-dropdown :selected').val()
    let region = $('#region-dropdown :selected').val()
    let municipality = $('#municipality-dropdown :selected').val()
    let city = event.target.value
    $('#city-landing-path').attr("href", `${province}/${region}/${municipality}/${city}`)
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

  $('#district-dropdown').on('change', function(event) {
    let districtId = event.target.value
    $.ajax({
      url: `/home/get_neighborhoods?district_id=${districtId}`,
      method: "GET",
      dataType: "json",
    }).done(function( response ) {
      resetNeighbourhood();
      $('#district-path').attr("href", `${response.route}/${districtId}`)
      $.each(response.neighborhoods, function(index, neighborhood) {
        $('#neighbourhood-dropdown').append($('<option>', {
            value: neighborhood.slug,
            text: neighborhood.neighborhd
        }));
      })
    });
  })

  function resetNeighbourhood() {
    $('#neighbourhood-dropdown').find('option').remove();
    $('#neighbourhood-dropdown').append($('<option>', {
      text: "Sub Neighbourhood"
    }));
  }
})