class CreateSocialProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :social_profiles do |t|
      t.integer :social_network, null: false
      t.string :uid, null: false
      t.string :access_token, null: false
      t.string :access_token_secret

      t.references :owner, polymorphic: true, index: true

      t.timestamps
    end
  end
end
