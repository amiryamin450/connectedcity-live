var fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};

$(function () {
  // Initialize the jQuery File Upload widget:
  $('#fileupload').fileupload({
    fileInput: $('#product_product_images_attributes_0_image'),
    limitMultiFileUploads: 5,
    maxFileSize: 5000000
  });
  //
  // Load existing files:
  // fix below for browser back/forward buttons when erroneous AJAX call was made to action
  // when $('#fileupload').prop('action') was returning undefined. 
  // # TODO: This partial should only be rendered when it's actually needed, instead of in the application layout.
  var url = $('#fileupload').prop('action');
  if(jQuery.type( url ) !== "undefined")
  {
    $.getJSON($('#fileupload').prop('action'), function (data) {
        var fu = $('#fileupload').data('blueimpFileupload'),
                template;
        fu._adjustMaxNumberOfFiles(-data.length);
        template = fu._renderDownload(data)
                .appendTo($('#fileupload .files'));
        // Force reflow:
        fu._reflow = fu._transition && template.length &&
                template[0].offsetWidth;
        template.addClass('in');
        $('#loading').remove();
    });
  }
});


$("#fileupload").validate({
  rules: {
    'product[name]': {
      required: true,
      minlength: 10,
      maxlength: 100,
    },
    'product[description]': {
      required: true,
      minlength: 100,
      maxlength: 1500,
    },
    'product[sku]': {
      required: false,
      maxlength: 1,
    },
    'product[price]': {
      required: true,
      range: [1, 1000000],
      digits: true
    },
    'product[quantity]': {
      required: true,
      minlength: 1,
      maxlength: 6,
      digits: true
    }
  }
});