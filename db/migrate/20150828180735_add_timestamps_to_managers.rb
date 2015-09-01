class AddTimestampsToManagers < ActiveRecord::Migration
  def change
    change_table(:managers) { |t| t.timestamps }
  end
end
