namespace :vertical_market_categories do
  task :create => :environment do
    ActiveRecord::Base.transaction do

      names = [
        'Mayor',
        'Deputy Major',
        'City Manager',
        'Deputy City Manager',
        'Chief Financial Officer',
        'Police Chief',
        'Fire Chief',
        'Director of Economic Development',
        'Director of City Planning',
        'Director of Public Works',
        'Chief Human Resources Officer',
        'Chief Legal Officer',
        'General Manager - Art, Culture & Community',
        'General Manager - Buildings, Development & Listings',
        'General Manager - Engineering Services',
        'Chief Communications Officer',
        'City Councillors',
        'Parks & Recreation Commissioners'
      ]
      vertical_market_government = VerticalMarket.where(slug: "municipal-government")[0]
      ids = names.map do |n|
        vt = VerticalMarketCategory.create({ name: n, vertical_market_id: vertical_market_government.id })
        vt.id
      end
      puts ids
    end
  end
end
