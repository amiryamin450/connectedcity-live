jQuery ->
  if $('form .tabbable .error').length > 0
    console.log 'errror tab'
    href = $('form .error').first().closest('.tab-pane').attr 'id'
    $('form .tabbable .tab-pane').removeClass 'active'
    $('form .error').first().closest('.tab-pane').addClass 'active'
    $('.tabbable .nav li').removeClass 'active'
    $('.tabbable .nav li a[href="#'+href+'"]').closest('li').addClass 'active'
