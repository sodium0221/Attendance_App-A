class RemoveFinishOvertimeFromUsers < ActiveRecord::Migration[5.1]
  def down
    remove_column :users, :finish_overtime, :datetime
    remove_column :users, :next_day, :boolean
    remove_column :users, :operation, :string
    remove_column :users, :superior_marking, :string
  end
end
