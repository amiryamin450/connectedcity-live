class AddPrimaryKeyToCity < ActiveRecord::Migration[7.0]
  def up
    rename_column :maponics_subdivisions, :csduid, :id
    change_column :maponics_subdivisions, :id, :integer
    change_column :maponics_subdivisions, :id, :primary_key
  end
  def down
    execute "ALTER TABLE maponics_subdivisions MODIFY id INT NOT NULL"
    execute "ALTER TABLE maponics_subdivisions DROP PRIMARY KEY"
    rename_column :maponics_subdivisions, :id, :csduid
    execute "ALTER TABLE `maponics_subdivisions` CHANGE `csduid` `csduid` CHAR(7) NULL DEFAULT NULL"
  end
end
