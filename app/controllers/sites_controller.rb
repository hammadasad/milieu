class SitesController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_site

  def index
    @sites = Site.all
  end

  def new
  end

  def create
    @site = current_user.sites.build(site_params)
    if @site.save
      redirect_to site_path(@site), notice: "site posted"
    else
      flash.now[:alert] = "Could not post your site"
      render 'new'
    end
  end

  def show
    @comment = @site.comments.build
  end

  def edit
  end

  def update
    if @site.update_attributes(site_params)
      redirect_to sites_path(@site)
    else
      flash.now[:alert] = "Could not update site"
      render :edit
    end
  end

  def destroy
    @site.destroy
    redirect_to root_path, flash: {notice: "Site removed"}
  end

  private
    def site_params
      params.require(:site).permit(:address,:lattitude,:longitude,:description,:contact_info,:status)
    end

    def load_site
      @site = Site.find(params[:id])
    end
end
