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
      flash[:success] = "拠点情報が追加されました"
      redirect_to @site
    else
      flash[:danger] = "拠点情報を追加できませんでした"
      render sites_url
    end 
  end
  
  def destroy
    @site.destroy
    flash[:success] = "削除しました。"
    redirect_to sites_url
  end
  
  def edit_site_info
  end
  
  def update_site_info
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
