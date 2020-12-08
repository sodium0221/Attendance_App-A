class AddOutoftimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :out_of_time, :integer
  end
end
