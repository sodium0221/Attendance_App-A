class AddStartedaftToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_aft, :datetime
    add_column :attendances, :finished_aft, :datetime
  end
end
