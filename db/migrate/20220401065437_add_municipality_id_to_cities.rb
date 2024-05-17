class AddMunicipalityIdToCities < ActiveRecord::Migration[7.0]
  def change
    add_column :maponics_subdivisions, :municipality_id, :integer
  end
end
