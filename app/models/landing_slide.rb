# Slideshow content (image, title, subtitle and links) for the landing pages, keyed the same
# way the Prismic documents were (home_page, city slug, city-district-neighbourhood, …).
# Copied from Prismic in October 2026; images are in the storage bucket under prismic_slides/,
# and the file holds their paths in the bucket.
class LandingSlide
  SLIDES = JSON.parse(File.read(Rails.root.join('config', 'landing_slides.json'))).transform_values do |slides|
    slides.map { |slide| slide['image'].present? ? slide.merge('image' => FileStorage.url(slide['image'])) : slide }
  end.freeze

  def self.for(key)
    SLIDES.fetch(key.to_s, [])
  end
end
