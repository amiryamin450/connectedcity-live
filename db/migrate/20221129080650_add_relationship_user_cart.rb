class AddRelationshipUserCart < ActiveRecord::Migration
  def up
    add_column :users, :cart_id, :integer unless column_exists?(:users, :cart_id)
    add_column :provinces, :tax_pst, :float, default: 0.0 unless column_exists?(:provinces, :tax_pst)
    add_column :provinces, :tax_gst, :float, default: 0.0 unless column_exists?(:provinces, :tax_gst)
    add_column :provinces, :tax_hst, :float, default: 0.0 unless column_exists?(:provinces, :tax_hst)
    add_column :carts, :user_id, :integer unless column_exists?(:carts, :user_id)
    add_index :carts, :user_id unless index_exists?(:carts, :user_id)

    Province.connection.execute("UPDATE provinces SET tax_pst = #{0.07}, tax_gst = #{0.05}")
  end

  def down
    change_table(:carts) do |t|
      t.remove_index :user_id if index_exists?(:carts, :user_id)
      t.remove_column :user_id if column_exists?(:carts, :user_id)
    end
    change_table(:users) do |t|
      t.remove_column :cart_id if column_exists?(:users, :cart_id)
    end
    change_table(:provinces) do |t|
      t.remove_column :tax_pst if column_exists?(:provinces, :tax_pst)
      t.remove_column :tax_gst if column_exists?(:provinces, :tax_gst)
      t.remove_column :tax_hst if column_exists?(:provinces, :tax_hst)
    end
  end
end
