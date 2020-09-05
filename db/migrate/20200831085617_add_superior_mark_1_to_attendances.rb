class AddSuperiorMark1ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_mark1, :string
    add_column :attendances, :superior_mark2, :string
  end
end
