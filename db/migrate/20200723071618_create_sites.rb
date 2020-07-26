class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.integer :site_number
      t.string :site_name
      t.string :site_status

      t.timestamps
    end
  end
end
