class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  with_options on: :overtime_vali do
    validate :finish_overtime_calling
    validates :operation, length: { maximum: 20 }, presence: true
    validates :superior_marking, presence: true
  end
  
  with_options on: :overtime_mess_vali do
    validate :hoge
    validate :hoga
  end
  
  enum request_status:{
    "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3
  }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end

  def finish_overtime_calling
    if finish_overtime == nil
      errors.add(:finish_overtime, "を入力してください")
    elsif month_day_adjustment(finish_overtime, user.designated_work_end_time) > user.designated_work_end_time && next_day == 1
      errors.add(:next_day, "のチェックを外してください")
    elsif month_day_adjustment(finish_overtime, user.designated_work_end_time) < user.designated_work_end_time && next_day == 0
      errors.add(:next_day, "のチェックを入れてください")
    end 
  end
  
    #月日の調整用
  def month_day_adjustment(f, d)
    f.change(month: d.month, day: d.day)
  end
  
  def hoge
    errors.add(:request_status, "を承認か否認にしてください") if request_status == "なし" || request_status == "申請中"
  end
  
  def hoga
    errors.add(:chg, "にチェックを入れてください") if chg == 0
  end
    
    
end