# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#business_user_tokens').tokenInput '/users.json',
    theme: 'facebook',
    propertyToSearch: 'email',
    prePopulate: $('#business_user_tokens').data('load')

  $('#business_location_tokens').tokenInput '/locations.json',
    theme: 'facebook',
    prePopulate: $('#business_location_tokens').data('load'),
    minChars: 3,
    resultsLimit: 10