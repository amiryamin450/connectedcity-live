class AddTimestampsToManagers < ActiveRecord::Migration[7.0]
  def change
    change_table(:managers) { |t| t.timestamps }
  end
end
