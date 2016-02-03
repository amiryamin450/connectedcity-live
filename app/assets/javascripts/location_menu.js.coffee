
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



  $('.chooser-mega #mega-ca a.district-select').click ->
    $('#district-select').find('div').find('a').removeClass('selected')
    # $('#' + $(this).data('toggle')).show().siblings().hide()
    redirect = baseURL + '/districts/' + $(this).data('slug')

  $('#btn-facet').click ->
    $('#facet-block').toggle()
