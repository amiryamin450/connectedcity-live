jQuery ->
  $('.location-menu-image').click (event) ->
    # dynamically set location name and image src by grabbing clicked element's corresponding data attributes
    $('#menu_image .location-name').html($(this).data('location-name'))
    $('#menu_image .location-menu-modal-body').html('<img src="' + $(this).data('image') + '" />')
