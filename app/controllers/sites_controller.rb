class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy, :edit_site_info, :update_site_info]
  def new
    @site = Site.new
  end
  
  def index
    @sites = Site.all
  end
  
  def edit
  end
  
  def create
    @site = Site.new(site_params)
      if @site.save
        flash[:success] = "拠点情報を追加しました。"
        redirect_to sites_url
      else
        render :index
      end
  end
  
  def update
    if @site.update_attributes(site_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = "更新は失敗しました。"
    end 
      redirect_to sites_url
  end
  
  def destroy
    @site.destroy
    flash[:success] = "削除しました。"
    redirect_to sites_url
  end
  
  def edit_site_info
  end
  
  def update_site_info
    if @site.update_attributes(site_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = "更新は失敗しました。"
    end 
      redirect_to sites_url
  end
  
  # beforeフィルター
  def set_site
    @site = Site.find(params[:id])
  end
  
  private
  
    def site_params
      params.require(:site).permit(:site_number, :site_name, :site_status)
    end
end
