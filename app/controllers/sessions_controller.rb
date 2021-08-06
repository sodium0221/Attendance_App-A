class SessionsController < ApplicationController
  before_action :reject_logged_in, only: :new
  
  def new
    @condition = logged_in?
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "認証に失敗しました。"
      render :new
    end 
  end 
  
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end 
end
