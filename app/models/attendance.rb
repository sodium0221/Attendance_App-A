class Attendance < ApplicationRecord
  belongs_to :user
  has_one :log

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  with_options on: :overtime_vali do
    validate :finish_overtime_calling
    validates :operation, length: { maximum: 50 }, presence: true
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
  
  with_options on: :update_one_month_vali do
    validate :finished_temp_is_invalid_without_a_started_temp
    validate :one_month_request_status_check
    validate :note_only_is_invalid
    validate :next_day1_confirmation
    validates :note, presence: true, length: { maximum: 20 }
    validates :superior_mark2, presence: true
  end
  
  with_options on: :one_month_accept_vali do
    validate :one_month_accept_chg_check
    validate :one_month_accept_status_check
  end
  
  enum request_status:{
    "なし": 0, "申請中": 1, "承認": 2, "否認": 3
  }
  
  enum superior_status1:{
    none: 0, pending: 1, acceptation: 2, denegation: 3
  }, _prefix: true
  
  enum superior_status2:{
    "なし": 0, "申請中": 1, "承認": 2, "否認": 3
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
  
  def finished_temp_is_invalid_without_a_started_temp
    errors.add(:started_temp, "が必要です") if started_temp.blank? && finished_temp.present?
  end
  
  def started_temp_than_finished_temp_fast_if_invalid
    if started_temp.present? && finished_temp.present?
      errors.add(:started_temp, "より早い退勤時間は無効です") if started_temp > finished_temp
    end
  end
  
  # 指示者確認が存在し、備考のみ存在する場合、無効
  def note_only_is_invalid
    if note.present?
      errors.add(:note, "のみの記入は無効です") if started_temp.blank? || finished_temp.blank?
    end 
  end

  # 翌日チェックのバリデーション
  def next_day1_confirmation
    if started_temp.nil? && finished_temp.nil?
      errors.add(:started_temp, "を入力してください")
    elsif started_temp.present? && finished_temp.nil?
      errors.add(:finished_temp, "を入力してください")
    elsif started_temp.nil? && finished_temp.present?
      errors.add(:started_at, "を入力してください")
    elsif (finished_temp > started_temp) && next_day1 == 1
      errors.add(:next_day, "のチェックを外してください")
    elsif (finished_temp < started_temp) && next_day1 == 0
      errors.add(:next_day, "のチェックを入れてください")
    end 
  end
  
  def one_month_accept_status_check
    errors.add(:superior_status2, "を承認か否認にしてください") if superior_status2 == "なし" || superior_status2 == "申請中"
  end
  
  def one_month_accept_chg_check
    errors.add(:chg2, "にチェックを入れてください") if chg2 == 0
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
  
  def one_month_request_status_check
    if started_temp.present? && superior_mark2.nil?
      errors.add(:superior_mark2, "を選択してください")
    elsif finished_temp.present? && superior_mark2.nil?
      errors.add(:superior_mark2, "を選択してください")
    elsif note.present? && superior_mark2.nil?
      errors.add(:superior_mark2, "を選択してください")
    end
  end
  
  def deano_message_request_status_check
    errors.add(:superior_status1, "を承認か否認にしてください") if superior_status1 == "pending"
  end
  
  def deano_message_chg_check
    errors.add(:chg1, "にチェックを入れてください") if chg1 == 0
  end
  
  def self.to_csv
    headers = %(日付 出社 退社)
    csv_data = CSV.generate(headers: headers, write_headers: true) do |csv|
      all.each do |row|
        csv << row.attributes.values_at(*self.column_names)
      end 
    end 
    csv_data.encode(Encoding::SJIS)
  end 
  
end