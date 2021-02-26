class AddChgToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :chg1, :integer
    add_column :attendances, :chg2, :integer
  end
end
