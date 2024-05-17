class FixCityWestKelownaToPresent < ActiveRecord::Migration[7.0]
  def up
    City.where('slug like ?', 'west-kelowna').first.update_column(:municipality_id, 344)
  end
end
