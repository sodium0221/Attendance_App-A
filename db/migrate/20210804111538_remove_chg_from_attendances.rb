class RemoveChgFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :chg, :integer
  end
end
