jQuery ->
  myDropzone = $("#new_status_update .dropzone").dropzone({ 
    url: $("#new_status_update").attr('action'),
    autoProcessQueue: false, 
    dictDefaultMessage: "Click, or drop a file here to upload.",
    paramName: 'status_update[image]',
    maxFiles: 1,
    addRemoveLinks: true,
    sending: (file, xhr, formData) ->
      formData.append('authenticity_token', $('#new_status_update input[name=authenticity_token]').val())
      formData.append('status_update[content]', $('#new_status_update #status_update_content').val())
    ,
    success: (file) ->
      new_status_update_success()
    ,
    error: (file, data, xhr) ->
      new_status_update_fail(data)

      imageFail = Object.keys(data.errors).reduce (a, b) ->
        if(/^image/.test(b)) 
          a.push(b)
        return a
      , []
      
      imageFail = imageFail.length > 0

      if(imageFail)
        myDropzone[0].dropzone.removeFile(file)
      else
        file.processing = false
        file.status = Dropzone.QUEUED
  })

  $('#status-update-submit').click (event) ->
    event.preventDefault()
    if(myDropzone[0].dropzone.getQueuedFiles().length > 0)
      myDropzone[0].dropzone.processQueue()
    else
      request = $.post $("#new_status_update").attr('action'), $("#new_status_update").serialize()
      request.done (data) ->
        new_status_update_success()
      request.fail (xhr) ->
        new_status_update_fail(xhr.responseJSON)

  $('.status-update-image').click (event) ->
    # dynamically set location name and image src by grabbing clicked element's corresponding data attributes
    $('#status_update_image .location-name').html($(this).data('location-name'))
    $('#status_update_image .modal-body').html('<img src="' + $(this).data('large-image') + '" />')

@new_status_update_success = () ->
  $('#status_update').modal('hide')
  location.reload()

@new_status_update_fail = (data) ->
  $('#status_update .alert').remove()

  errors = Object.keys(data.errors).map (value) ->
    return data.errors[value][0]

  div = $('<div class="alert alert-error">').html(errors.join("<br />"))
  $('#status_update .modal-body').prepend(div)