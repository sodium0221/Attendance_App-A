class ChangeDataNextdayToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :chg, :integer
  end
end
