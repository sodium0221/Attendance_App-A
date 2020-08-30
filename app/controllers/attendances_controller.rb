class AttendancesController < ApplicationController
  include AttendancesHelper
  
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_overtime_message, :update_overtime_message]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end 
    end 
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def approval_alert
  end

  
  def edit_overtime_motion
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
    @overtime_users = Attendance.where(superior_marking: current_user.name)
    @superiors = User.where(superior: true)
  end 
  
  def update_overtime_motion
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業を申請しました。"
      @attendance.update_attributes(request_status: 1)
    else
      flash[:danger] = "残業の申請ができませんでした。<br>" + @attendance.errors.full_messages.join("<br>")
    end 
    redirect_to @user
  end
  
  def edit_overtime_message
    @user = User.find(params[:id])
    @days = Attendance.where(superior_marking: current_user.name).pluck(:user_id).uniq
    @users = User.find(@days)
  end
  
  def update_overtime_message
    @user = User.find(params[:id])
    edit_overtime_message_params.each do |id, item|
      attendance = Attendance.find(id)
        if attendance.update_attributes(item)
          if attendance.chg == 1
            flash[:success] = "残業申請の変更を送信しました。"
            attendance.update_attributes(superior_marking: 0)
          else
            flash[:danger] = "「変更」にチェックを入れて下さい。"
          end
        end 
      end
    redirect_to @user
  end
  
  private
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end
  
  def overtime_params
    params.require(:attendance).permit(:finish_overtime, :next_day, :operation, :superior_marking, :request_status)
  end
  
  def edit_overtime_params
    params.require(:attendance).permit(:request_status, :chg)
  end
  
  def edit_overtime_message_params
    params.require(:user).permit(attendances: [:request_status, :chg])[:attendances]
  end
  
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end 
  end
end
