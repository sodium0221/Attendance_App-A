class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attendance_log, :attendance_log]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :attendance_log]
  def index
    @users = User.paginate(page: params[:page])
  end 
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @attendance = @user.attendances.where(worked_on: @first_day..@last_day)
    @mark1_day = @attendance.find_by(worked_on: @first_day)
    @notice = Attendance.where(superior_marking: current_user.name, request_status: 1)
    @notice_sum = @notice.count
    @att_notice = Attendance.where(superior_mark1: current_user.name, superior_status1: 1)
    @att_notice_sum = @att_notice.count
    @superiors = User.where(superior: true).where.not(name: current_user.name)
    @notice_superior = Attendance.where(superior_marking: current_user.name)
    @notice_superior_sum = @notice_superior.count
    @att_change_alert = Attendance.where(superior_mark2: current_user.name, superior_status2: 1)
    @att_change_alert_sum = @att_change_alert.count
  end 
  
  def new
    @user = User.new
    @attendances = User.first.attendances.pluck(:worked_on)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end 
  end 
  
  def edit
  end 
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to @user
    else
      render :edit
    end 
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] ="#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end 
    redirect_to users_url
  end
  
  def import
    User.import(params[:file])
    redirect_to root_url
  end
  
  def attending_member
    @working_users_id = Attendance.where(worked_on: Date.today, finished_at: nil).where.not(started_at: nil).pluck(:user_id).uniq
    @users = User.find(@working_users_id)
  end

  
  def edit_overtime_message
    @user = User.find(params[:id])
  end
  
  def update_overtime_message
  end
  
  def attendance_log
  end
  
  def attendance_log_search
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, 
                                   :password_confirmation, :employee_number, 
                                   :uid, :designated_work_star_time,
                                   :designated_work_end_time)
    end
    
    def basic_info_params
      params.require(:user).permit(:affiliation, :basic_time, :work_time)
    end
end
