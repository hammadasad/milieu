class SitesController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_site

  def index
    #@sites = Site.search(params[:search])
    @sites = if params[:search]
      Site.near(params[:search], 1, units: :km)
    elsif params[:latitude] && params[:longitude]
      Site.near([params[:latitude],params[:longitude]], 2, units: :km)
    else
      Site.all
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to site_path(@site), notice: "site posted"
    else
      flash.now[:alert] = "Could not post your site"
      render 'new'
    end
  end

  def show
    @nearby_sites = @site.nearbys(2, units: :km)
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
      if params[:id] != nil
        @site = Site.find(params[:id])
      end
    end
end
