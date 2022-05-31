class AddMunicipalityIdToCities < ActiveRecord::Migration
  def change
    add_column :maponics_subdivisions, :municipality_id, :integer
  end
end
