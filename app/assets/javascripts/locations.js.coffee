# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#datepicker_starts, #datepicker_ends').datetimepicker
    language: 'en',
    pick12HourFormat: true,
    pickSeconds: false

  $('#location_brand_tokens').tokenInput '/brands_autocomplete.json',
    theme: 'facebook',
    propertyToSearch: 'name',
    prePopulate: $('#location_brand_tokens').data('load'),
    resultsLimit: 10

  $('.status-tabs ul').each ->
    $active = $content = $links = $(this).find 'a'

    $active = $($links.filter('[href="' + location.hash + '"]')[0] || $links[0])
    $active.addClass 'active'
    $content = $($active.attr 'href')
    
    $links.not($active).each ->
      $($(this).attr 'href').hide()

    $(this).on 'click', 'a', (e) ->
      $active.removeClass 'active'
      $content.hide()

      $active = $(this)
      $content = $($(this).attr 'href')

      $active.addClass 'active'
      $content.show()

      e.preventDefault()

  $('#location_content').wysihtml5()

  $('.menu-toggle').click ->
    $('#sidebar').toggleClass('menu-min')
    $.cookie("sidebar_class", $('#sidebar').attr('class'))
    return false

  $('.carousel').carousel({
    interval: false
  })

  $('.dropdown-toggle').click ->
    $target = $('#' + $(this).data('toggle'))
    $('#sidebar').removeClass('menu-min')
    if $target.is(':visible') 
      $(this).find('b').removeClass('icon-angle-down').addClass('icon-angle-right')
      $target.slideUp(200)
      $target.toggleClass('hide')
    else
      $(this).find('b').removeClass('icon-angle-right').addClass('icon-angle-down')
      $target.slideDown(200)
      $target.toggleClass('hide')
    return false