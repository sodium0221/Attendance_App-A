class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
      
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end 
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      @user = User.find(params[:id])
      unless current_user.admin?
        unless current_user?(@user)
          redirect_to(root_url)
        end 
      end
    end
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end 
    
    # システム管理者権限所有の人出ない人を判断
    def non_admin_user
      redirect_to root_url if current_user.admin?
    end
    
    # ログイン済みユーザーにログイン画面を表示させない
    def reject_logged_in
      redirect_to root_url if current_user.present?
    end
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    # ユーザーに紐付く1ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end 
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end 
    
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end 
  
  def set_user2
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
  end
  
  def create_csv_file_header(csv_file_name)
    file_name = ERB::Util.url_encode(file_name) if (/MSIE/ =~ request.user_agent) || (/Trident/ =~ request.user_agent)
    headers['Content-Disposition'] = "attachment; filename=\"#{file_name}.csv\""
  end
end
