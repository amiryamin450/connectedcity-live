class ChangePostalCodeFieldNameOnClassifiedListings < ActiveRecord::Migration
  def up
    rename_column :classified_listings, :prostal_code, :postal_code
  end

  def down
    rename_column :classified_listings, :postal_code, :prostal_code
  end
end
