class ChangeDataFinishOvertimeAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :finish_overtime, :datetime
  end
end
