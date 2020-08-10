class AddOvertimeInfoToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :finish_overtime, :datetime
    add_column :attendances, :next_day, :boolean
    add_column :attendances, :operation, :string
    add_column :attendances, :superior_marking, :string
  end
end
