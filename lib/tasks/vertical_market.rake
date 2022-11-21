namespace :vertical_market do
  task :update_local_government => :environment do
    vertical_market_government = VerticalMarket.where(slug: "local-government")[0]
    vertical_market_news = VerticalMarket.create({ name: 'Civic News', slug: 'civic-news' })
    vertical_market_government.parent_id = vertical_market_news.id
    vertical_market_government.save
  end

  task :add_trending_vertical_market => :environment do
    vertical_market_trending = VerticalMarket.create({ name: 'Trending', slug: 'trending' })
    vertical_market_trending.save
  end
end
