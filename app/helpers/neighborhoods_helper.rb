module NeighborhoodsHelper
  NAME_MAPPING = {
    "Fairview" => "Fairview - Granville Island",
    "Granville Island" => ""
  }

  def neighborhood_link(neighborhood)
    if neighborhood
      display_link_text = NAME_MAPPING[neighborhood.name] || neighborhood.name
      if display_link_text.present?
        link_to(display_link_text,
          district_neighborhood_guide_path(params[:district_route], neighborhood.slug, params[:market]),
          class: (neighborhood.slug == params[:neighborhood] ? 'active' : ''))
      end
    end
  end
end