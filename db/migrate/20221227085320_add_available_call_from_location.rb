class AddAvailableCallFromLocation < ActiveRecord::Migration
  def change
    add_column :locations, :available_call, :boolean, default: true
  end
end
