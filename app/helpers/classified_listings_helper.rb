module ClassifiedListingsHelper
  def image_size_words(listing)
    if listing.classified_images.present? and listing.classified_images.size > 0
      "Yes (#{listing.classified_images.size})"
    else
      "No"
    end
  end

  def classified_condition(listing)
    CLASSIFIED_CONDITION_OPTIONS.key(listing.condition)
  end

end
