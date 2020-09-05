class AddEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :end_time, :datetime
  end
end
