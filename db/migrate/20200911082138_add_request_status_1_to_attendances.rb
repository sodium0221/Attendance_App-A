class AddRequestStatus1ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_status1, :integer, default: 0
    add_column :attendances, :superior_status2, :integer, default: 0
  end
end
