class ChangeDataNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :next_day, :integer
    change_column :attendances, :chg, :integer
  end
end
