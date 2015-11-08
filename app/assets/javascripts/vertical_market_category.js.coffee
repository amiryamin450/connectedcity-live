# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->
  $('a.see-more').click ->
    id = $(this).data('element')
    $('#cat-' + id).toggleClass 'show'
    if($(this).html() == "More +")
      $(this).html "Less +"
    else
      $(this).html "More +"
    return false

  if word_list
    $('#tag_cloud').jQCloud(word_list);
