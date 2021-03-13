class AddNextdayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day1, :integer
  end
end
