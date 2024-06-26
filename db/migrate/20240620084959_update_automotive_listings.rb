class UpdateAutomotiveListings < ActiveRecord::Migration[7.0]
  def up
    change_column :automotive_listings, :status, :integer, default: 0
    add_column :automotive_listings, :accident_description, :string
    change_column :automotive_listings, :powertrain_specs, :string
    change_column :automotive_listings, :suspension_specs, :string
    change_column :automotive_listings, :specs, :string
    change_column :automotive_listings, :entertainment_features, :string
    change_column :automotive_listings, :seats_and_trim, :string
    change_column :automotive_listings, :convenience_features, :string
    change_column :automotive_listings, :body_exterior, :string
    change_column :automotive_listings, :lighting_visibility_instruments, :string
    change_column :automotive_listings, :saftey_and_security, :string
  end

  def down
    change_column :automotive_listings, :status, :string
    remove_column :automotive_listings, :accident_description, :string
    change_column :automotive_listings, :powertrain_specs, :text
    change_column :automotive_listings, :suspension_specs, :text
    change_column :automotive_listings, :specs, :text
    change_column :automotive_listings, :entertainment_features, :text
    change_column :automotive_listings, :seats_and_trim, :text
    change_column :automotive_listings, :convenience_features, :text
    change_column :automotive_listings, :body_exterior, :text
    change_column :automotive_listings, :lighting_visibility_instruments, :text
    change_column :automotive_listings, :saftey_and_security, :text
  end
end
