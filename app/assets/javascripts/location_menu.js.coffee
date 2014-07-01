
jQuery ->   
  redirect = window.redirectURL
  open = false

  if $.cookie('selected_country')
    $('#mega-' + $.cookie('selected_country')).show()
    $('a.country-select.' + $.cookie('selected_country')).addClass('active')
  else
    $.cookie('selected_country', 'ca')
    $('a.country-select.ca').addClass('active')
    $('#mega-ca').show()


  $('.location-chooser .chooser').click ->
    if !open
      open = true
      $(this).addClass('over')
      width = $(this).outerWidth()
      mega = $('.chooser-mega')
      mega.css({left: -1 * (mega.outerWidth() - width) + 1 }).slideDown('fast')
      mega.click (e) ->
        e.stopPropagation()
    else
      $('.chooser-mega').slideUp('fast').removeClass('over')
      open = false




  $('.chooser-mega .btn-cancel').click ->
    $('.location-chooser .chooser').click()

  $('.chooser-mega .btn-go').click ->
    window.location.replace(protocol + redirect)

  $('.chooser-mega li a').click ->
    $(this).addClass('selected').parent().siblings().find('a').removeClass('selected')

    # us

  $('.chooser-mega #mega-us  a.region-select').click ->
    $('#sub-region-select-us, #city-select-us, #district-select-us').find('div').hide()
    $('#sub-region-select-us, #city-select-us, #district-select-us').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $(this).data('subdomain') + '.' + baseURL

  $('.chooser-mega #mega-us a.sub-region-select').click ->
    $('#city-select-us, #district-select-us').find('div').hide()
    $('#city-select-us, #district-select-us').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $('#metro-select-us').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $(this).data('slug')
    
  $('.chooser-mega #mega-us a.city-select').click ->
    $('#district-select-us').find('div').hide()
    $('#district-select-us').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $('#metro-select-us').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $('#sub-region-select-us').find('a.selected').data('slug') + '/' + $(this).data('slug')
    
  $('.chooser-mega #mega-us a.district-select').click ->
    redirect = $('#metro-select-us').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $('#sub-region-select-us').find('a.selected').data('slug') + '/' + $('#city-select-us').find('a.selected').data('slug') + '/' + $(this).data('slug')

  # canada

  $('.chooser-mega #mega-ca a.region-select').click ->
    $('#sub-region-select-ca, #city-select-ca, #district-select-ca').find('div').hide()
    $('#sub-region-select-ca, #city-select-ca, #district-select-ca').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $(this).data('subdomain') + '.' + baseURL

  $('.chooser-mega #mega-ca a.sub-region-select').click ->
    $('#city-select-ca, #district-select-ca').find('div').hide()
    $('#city-select-ca, #district-select-ca').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $('#metro-select-ca').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $(this).data('slug')
    
  $('.chooser-mega #mega-ca a.city-select').click ->
    $('#district-select-ca').find('div').hide()
    $('#district-select-ca').find('a').removeClass('selected')
    $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = $('#metro-select-ca').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $('#sub-region-select-ca').find('a.selected').data('slug') + '/' + $(this).data('slug')
    
  $('.chooser-mega #mega-ca a.district-select').click ->
    redirect = $('#metro-select-ca').find('a.selected').data('subdomain') + '.' + baseURL + '/region/' + $('#sub-region-select-ca').find('a.selected').data('slug') + '/' + $('#city-select-ca').find('a.selected').data('slug') + '/' + $(this).data('slug')


  $('#btn-facet').click ->
    $('#facet-block').toggle()

  $('a.country-select').click ->
    $('a.country-select').removeClass('active')
    $(this).addClass('active')
    $('div.country-holder').hide()
    $('#' + $(this).data('target')).show()
    $.cookie('selected_country', $(this).data('country'))


