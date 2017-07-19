jQuery ->
  $('#city_news_article_district_id').change (event) ->

    # show loading and clear options
    loadingOption = $('<option></option>').attr("value", "").text("Loading...")
    $('#city_news_article_neighborhood_id').empty().append(loadingOption)

    selectedNeighborhood = $('#city_news_article_neighborhood_id').data('selected');

    $.ajax
      url: '/neighborhoods/list?'
      dataType: "json"
      data: { 'district_id': $(this).val() }
      error: (jqXHR, textStatus, errorThrown) ->
        errorOption = $('<option></option>').attr("value", "").text("Error loading neighborhoods")
        $('#city_news_article_neighborhood_id').empty().append(errorOption)
      success: (data, textStatus, jqXHR) ->
        pleaseSelectOption = $('<option></option>').attr("value", "").text("please select (optional)")
        $('#city_news_article_neighborhood_id').empty().append(pleaseSelectOption)
        $.each data, (index, neighborhood) ->
          if selectedNeighborhood? and selectedNeighborhood == neighborhood.nid
            newOption = $('<option selected="selected"></option>').attr("value", neighborhood.nid).text(neighborhood.neighborhd)
          else
            newOption = $('<option></option>').attr("value", neighborhood.nid).text(neighborhood.neighborhd)
          $('#city_news_article_neighborhood_id').append(newOption)
        $('#city_news_article_neighborhood_id').prop('disabled', false)

  $('#city_news_article_district_id').trigger('change')
