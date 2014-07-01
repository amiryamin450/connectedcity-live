module BusinessesHelper
  def link_to_add_business_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      builder.hidden_field :id
    end
    link_to(name, '#', class: "btn", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
