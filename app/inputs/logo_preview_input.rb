class LogoPreviewInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    out = ''
    # check if there's an uploaded file (eg: edit mode or form not saved)
    if object.send("#{attribute_name}?")
      out << "<div>#{template.image_tag(object.send(attribute_name).url(:thumb), :class => 'thumbnail', id: 'logo')}</div>"
    end
    # append file input. it will work accordingly with your simple_form wrappers
    (out << @builder.file_field(attribute_name, input_html_options)).html_safe
  end
end
