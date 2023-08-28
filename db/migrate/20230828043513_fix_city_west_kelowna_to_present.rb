class FixCityWestKelownaToPresent < ActiveRecord::Migration
  def up
    City.where('slug like ?', 'west-kelowna').first.update_column(:municipality_id, 344)
  end
end
