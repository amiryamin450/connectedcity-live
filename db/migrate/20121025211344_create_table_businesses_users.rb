class CreateTableBusinessesUsers < ActiveRecord::Migration
  def change
    create_table :businesses_users, :id =>false do |t|
      t.integer :user_id
      t.integer :business_id
    end
  end
end
