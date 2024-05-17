class AddAvailableCallFromLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :available_call, :boolean, default: true
  end
end
