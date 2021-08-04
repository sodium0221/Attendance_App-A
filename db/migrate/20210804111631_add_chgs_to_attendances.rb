class AddChgsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :chg, :integer
  end
end
