class AttendancesController < ApplicationController
  include AttendancesHelper
  
  before_action :set_user2, only: [:update_overtime_motion, :update_deano_motion, :edit_one_month_accept]
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_overtime_message, :update_overtime_message, :edit_deano_message, :confirm_one_month, :edit_one_month_accept, :update_one_month_accept]
  before_action :logged_in_user, only: [:update, :edit_one_month, :edit_one_month_accept]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :edit_one_month_accept]
  before_action :set_one_month, only: [:edit_one_month, :confirm_one_month, :update_overtime_motion, :edit_deano_motion, :update_deano_motion, :edit_one_month_accept]
  
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
    @superiors = User.where(superior: true).where.not(name: current_user.name)
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do       
      attendances_params.each do |id, item|         
        if params[:user][:attendances][id][:superior_mark2].present?           
          attendance = Attendance.find(id)           
          attendance.update(item)
          attendance.save!(context: :update_one_month_vali)           
          attendance.update_attributes!(superior_status2: 1)
        elsif params[:user][:attendances][id][:started_temp].present? ||
              params[:user][:attendances][id][:finished_temp].present? ||
              params[:user][:attendances][id][:note].present?
              raise ActiveRecord::RecordInvalid
        end
      end      
    end      
    flash[:success] = "勤怠変更を申請しました。"     
    redirect_to user_url(date: params[:date])   
  rescue ActiveRecord::RecordInvalid     
    flash[:danger] = "無効な入力があるので送信できませんでした。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_one_month_accept
    @user_id = Attendance.where(superior_mark2: current_user.name).pluck(:user_id).uniq
    @users = User.find(@user_id)
    @attendance = @user.attendances.where(worked_on: @first_day..@last_day)
    @superiors = User.where(superior: true).where.not(name: current_user.name)
  end
  
  def update_one_month_accept
    @user = User.find(params[:id])
    
    ActiveRecord::Base.transaction do
      attendances_accept_params.each do |id, item|
        @attendance = Attendance.find(id)
        @attendance.update(item)
        @attendance.save!(context: :one_month_accept_vali)
        @attendance.started_aft = @attendance.started_temp
        @attendance.finished_aft = @attendance.finished_temp
        @attendance.update_attributes(accept_day: Date.current)
      end 
    end 
    flash[:success] = "勤怠変更申請の変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = @attendance.errors.full_messages.join("<br>")
    redirect_to @user
  end
  

  
  def approval_alert
  end

  
  def edit_overtime_motion
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
    @overtime_users = Attendance.where(superior_marking: current_user.name)
    @superiors = User.where(superior: true).where.not(name: current_user.name)
  end 
  
  def update_overtime_motion
    @superiors = User.where(superior: true).where.not(name: current_user.name)
    @attendance.end_time = @user.designated_work_end_time.change(year: @attendance.worked_on.year,
                                                                 month: @attendance.worked_on.month,
                                                                 day: @attendance.worked_on.day)
    ActiveRecord::Base.transaction do
      @attendance.update(overtime_params)
      @attendance.update_attributes(finish_overtime: @attendance.finish_overtime.change(year: @attendance.worked_on.year, 
                                                                                        month: @attendance.worked_on.month, 
                                                                                        day: @attendance.worked_on.day))
      @attendance.save!(context: :overtime_vali)
    end
    @attendance.update_attributes(request_status: 1)
    flash[:success] = "#{l(@attendance.worked_on, format: :short)}の残業を申請しました"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "#{l(@attendance.worked_on, format: :short)}の残業を申請できませんでした<br>" + @attendance.errors.full_messages.join("<br>")
    redirect_to @user
  end
  
  def edit_overtime_message
    @user = User.find(params[:id])
    @days = Attendance.where(superior_marking: current_user.name, request_status: 1).pluck(:user_id).uniq
    @users = User.find(@days)
  end
  
  def update_overtime_message
    @user = User.find(params[:id])
    
    ActiveRecord::Base.transaction do
      edit_overtime_message_params.each do |id, item|
        @attendance = Attendance.find(id)
        @attendance.update(item)
        @attendance.save!(context: :overtime_mess_vali)
      end 
    end 
    flash[:success] = "残業申請の変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = @attendance.errors.full_messages.join("<br>")
    redirect_to @user
  end
    

  
  def confirm_one_month
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def edit_deano_motion
    @user = User.find(params[:id])
    @user_id = Attendance.where(superior_marking: current_user.name).pluck(:user_id).uniq
    @users = User.find(@user_id)
    @attendance = @user.attendances.where(worked_on: @first_day..@last_day)
    @superiors = User.where(superior: true).where.not(name: current_user.name)
  end
  
  def update_deano_motion
    @user = User.find(params[:id])
    @attendance = @user.attendances
    @mark1_day = @attendance.find_by(worked_on: @first_day)
    ActiveRecord::Base.transaction do
      @mark1_day.update(deano_motion_params)
      @mark1_day.save!(context: :deano_motion_vali)
    end
      flash[:success] = "#{@mark1_day.superior_mark1}に#{l(@first_day, format: :mon)}の勤怠承認を送信しました"
      @mark1_day.update_attributes(superior_status1: 1)
      redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "送信できませんでした。送信先を指定してください。"
    redirect_to @user
  end
  
  def edit_deano_message
    @user = User.find(params[:id])
    @days = Attendance.where(superior_mark1: current_user.name, superior_status1: 1).pluck(:user_id).uniq
    @users = User.find(@days)
  end 
  
  def update_deano_message
    @user = User.find(params[:id])
    ActiveRecord::Base.transaction do 
      deano_message_params.each do |id, item|
        @attendance = Attendance.find(id)
        @attendance.update(item)
        @attendance.save!(context: :deano_mess_vali)
      end 
    end 
    flash[:success] = "勤怠申請の変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = @attendance.errors.full_messages.join("<br>")
    redirect_to @user
  end
  
  private
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:started_temp, :finished_temp, :next_day1, :note, :superior_mark2])[:attendances]
  end
  
  def attendances_accept_params
    params.require(:user).permit(attendances: [:superior_status2, :chg2])[:attendances]
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
  
  def deano_motion_params
    params.require(:attendance).permit(:superior_mark1)
  end
  
  def deano_message_params
    params.require(:user).permit(attendances: [:superior_status1, :chg1])[:attendances]
  end
  
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end 
  end
end
