class ChangeDataRequestStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :request_status, :integer, default: 0
  end
end
