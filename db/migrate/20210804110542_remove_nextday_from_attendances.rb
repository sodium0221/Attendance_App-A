class RemoveNextdayFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :next_day, :string
  end
end
