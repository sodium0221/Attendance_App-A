class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.datetime :started_bfr
      t.datetime :finished_bfr
      t.datetime :started_aft
      t.datetime :finished_aft
      t.date :approval_day
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
