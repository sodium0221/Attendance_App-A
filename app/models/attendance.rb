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
    validate :overtime_message_request_status_check
    validate :overtime_message_chg_check
  end
  
  with_options on: :deano_motion_vali do
    validate :deano_motion_request_status_check
  end
  
  with_options on: :deano_mess_vali do 
    validate :deano_message_request_status_check
    validate :deano_message_chg_check
  end
  
  enum request_status:{
    "なし": 0, "申請中": 1, "承認": 2, "否認": 3
  }
  
  enum superior_status1:{
    none: 0, pending: 1, acceptation: 2, denegation: 3
  }, _prefix: true
  

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
    elsif (finish_overtime > end_time) && next_day == 1
      errors.add(:next_day, "のチェックを外してください")
    elsif (finish_overtime < end_time) && next_day == 0
      errors.add(:next_day, "のチェックを入れてください")
    end 
  end
  
    #月日の調整用
  def month_day_adjustment(f, d)
    f.change(month: d.month, day: d.day)
  end
  
  def overtime_message_request_status_check
    errors.add(:request_status, "を承認か否認にしてください") if request_status == "なし" || request_status == "申請中"
  end
  
  def overtime_message_chg_check
    errors.add(:chg, "にチェックを入れてください") if chg == 0
  end
  
  def deano_motion_request_status_check
    errors.add(:superior_mark1, "を選択してください") if superior_mark1 == ""
  end
  
  def deano_message_request_status_check
    errors.add(:superior_status1, "を承認か否認にしてください") if superior_status1 == 0 || superior_status1 == 1
  end
  
  def deano_message_chg_check
    errors.add(:chg1, "にチェックを入れてください") if chg1 == 0
  end
end