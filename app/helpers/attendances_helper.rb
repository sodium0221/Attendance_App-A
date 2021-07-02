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
  
  # 日付を"worked_on"に変更する
  def change_to_worked_on(finish_overtime, worked_on)
    finish_overtime.change(year: worked_on.year, month: worked_on.month, day: worked_on.day)
  end
    
  
  # 時間外時間算出
  def format_time_delta(att, user)
    att.end_time = user.designated_work_end_time.change(year: att.worked_on.year,
                                                        month: att.worked_on.month,
                                                        day: att.worked_on.day)
    if att.finish_overtime.present?
      if att.next_day == 1
        format("%.2f", ((((att.finish_overtime + 1.day) - att.end_time) / 60) / 60))
      else
        format("%.2f", (((att.finish_overtime - att.end_time) / 60) / 60))
      end
    end
  end
  
  # 指定勤務終了時間の調整
  def adjustment_out_of_time(att, user)
    att.end_time = user.designated_work_end_time.change(month: att.worked_on.month, day: att.worked_on.day)
    if att.finish_overtime.present?
      att.finish_overtime.change(month: att.worked_on.month, day: att.worked_on.day)
      if att.next_day == 1
        format("%.2f", (((att.finish_overtime.change(month: att.worked_on.month, day: att.worked_on.day) + 1.day - att.end_time) / 60) / 60))
      else
        format("%.2f", (((att.finish_overtime.change(month: att.worked_on.month, day: att.worked_on.day) - att.end_time) / 60) / 60))
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
  
  #勤怠申請の支持者確認表示
  def att_superior_status1(day)
    if day.superior_status1 == "申請中"
      day.superior_marking + "へ申請中"
    elsif day.superior_status1 == "承認"
      day.superior_marking + "から承認済"
    elsif day.superior_status1 == "否認"
      day.superior_marking + "から否認されました"
    end
  end
  
  def att_superior_status2(day)
    if day.superior_status2 == "申請中"
      day.superior_mark2 + "へ勤怠修正を申請中"
    elsif day.superior_status2 == "承認"
      day.superior_mark2 + "から勤怠修正が承認されました"
    elsif day.superior_status2 == "否認"
      day.superior_mark2 + "から勤怠修正が否認されました"
    end
  end
  
  # 勤怠編集画面の時間表示調整
  def show_time_field(day)
    l(day, format: :time) if day.present?
  end
  
  # showページの出社時間表示調整
  def show_started_time(day, f)
    if day.started_aft.present?
      l(day.started_aft, format: f)
    elsif day.started_at.present?
      l(day.started_at, format: f)
    end
  end
  
  # showページの退社時間表示調整
  def show_finished_time(day, f)
    if day.finished_aft.present?
      l(day.finished_aft, format: f)
    elsif day.finished_at.present?
      l(day.finished_at, format: f)
    end 
  end
  
  # 勤怠編集申請モーダルの時間表示調整
  def none_data_time_for_view(time, f)
    l(time, format: f) if time.present?
  end
  
  # 勤怠編集画面の条件分岐
  def s_mark2_confirm(item)
    if item.started_temp.present? && item.superior_mark2.nil?
      return false
    elsif item.finished_temp.present? && item.superior_mark2.nil?
      return false
    elsif item.note.present? && item.superior_mark2.nil?
      return false
    end 
  end
  
  # 勤怠ログ画面の時間表示
  def time_of_view(day)
    l(day, format: :time) if day.present?
  end
      
end
