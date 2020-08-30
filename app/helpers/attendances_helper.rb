module AttendancesHelper
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
    end 
    false
  end
  
  def quitting_state(attendance)
    if Date.current == attendance.worked_on
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end 
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  #残業申請モーダルの翌日チェックボックス の有無
  def next_day_check(day)
    if day.next_day?
      day.finish_overtime + 1.day
    end 
  end
  
  # 指示者確認表示
  def superior_mark_overtime(user)
    if user.request_status == 1
      "残業申請中"
    elsif user.request_status == 2
      "残業承認済"
    elsif user.request_status == 3
      "残業否認"
    end 
  end
end
