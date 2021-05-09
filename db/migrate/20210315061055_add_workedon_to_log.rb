class AddWorkedonToLog < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :worked_on, :date
  end
end
