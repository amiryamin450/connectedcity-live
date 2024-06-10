namespace :citizens do
  task :remove_duplicate_citizen_locations => :environment do
    emails = Location.unscoped.where(is_profile: true).pluck(:email).uniq

    emails.each do |email|
      locations = Location.unscoped.where(is_profile: true, email: email)
      if locations.size > 1
        locations.where.not(id: locations.first.id).destroy_all
      end
    end
  end

  task :add_manager_to_citizen_location => :environment do
    Location.unscoped.where(is_profile: true).each do |location|
      location.users << User.where(email: location.email)
    end
  end

  task :remove_duplicate_favorites => :environment do
    Favorite.where(category: "friends").each do |fav|
      favorites = Favorite.where(location_id: fav.location_id, user_id: fav.user_id)
      if favorites.size > 1
        favorites.where.not(id: favorites.first.id).destroy_all
      end
    end
  end
end
