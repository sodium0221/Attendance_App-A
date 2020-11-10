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
  
  # 時間外時間算出
  def format_time_delta(end_time, overtime, day)
    if end_time.present? && overtime.present?
      if day.next_day == 1
        format("%.2f", (((overtime + 1.day - end_time) / 60) / 60))
      else
        format("%.2f", (((overtime - end_time) / 60) / 60))
      end
    end
  end
  
  # 指定勤務終了時間の調整
  def adjustment_out_of_time(att, user)
    att.end_time = user.designated_work_end_time.change(month: att.worked_on.month, day: att.worked_on.day)
    if att.finish_overtime.present?
      if att.next_day == 1
        format("%.2f", (((att.finish_overtime + 1.day - att.end_time) / 60) / 60))
      else
        format("%.2f", (((att.finish_overtime - att.end_time) / 60) / 60))
      end
    end
  end
 
    
  
  #残業申請モーダルの翌日チェックボックス の有無
  def next_day_check(day)
    if day.next_day?
      day.finish_overtime + 1.day
    end 
  end
  
  # 指示者確認表示
  def superior_mark_overtime(day)
    if day.request_status == "申請中"
      day.superior_marking + "へ残業申請中"
    elsif day.request_status == "承認"
      "残業承認済"
    elsif day.request_status == "否認"
      "残業否認"
    end 
  end
end
