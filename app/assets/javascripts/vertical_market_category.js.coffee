# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->
  $('a.see-more').click ->
    id = $(this).data('element')
    $("[id='cat-" + id + "']").toggleClass('show')
    if($(this).html() == "See More +")
      $(this).html "See Less +"
    else
      $(this).html "See More +"
    return false

  if typeof word_list != 'undefined'
    $('#tag_cloud').jQCloud(word_list);

  product_descriptions = $('.featured-product-description')

  for product_desc in product_descriptions
    $clamp(product_desc, {clamp: 3})
