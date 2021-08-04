require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出社 退社)
  csv << column_names
  @attendances.each do |day|
    column_values = [
       day.worked_on.strftime("%m/%d"),
       show_started_time(day, :time),
       show_finished_time(day, :time)
    ]
    csv << column_values
  end
end