class AddStartedtempToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_temp, :datetime
    add_column :attendances, :finished_temp, :datetime
  end
end
