# Slideshow content (image, title, subtitle and links) for the landing pages, keyed the same
# way the Prismic documents were (home_page, city slug, city-district-neighbourhood, …).
# Copied from Prismic in October 2026; images are in the S3 bucket under prismic_slides/.
class LandingSlide
  SLIDES = JSON.parse(File.read(Rails.root.join('config', 'landing_slides.json'))).freeze

  def self.for(key)
    SLIDES.fetch(key.to_s, [])
  end
end
