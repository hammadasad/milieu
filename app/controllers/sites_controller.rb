class SitesController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_site


  def index
    
    require 'csv'
    
    counter = 0

    CSV.foreach(Rails.root + "app/assets/csv/activepermits2.csv") do |row|
      counter += 1

      parsed_site = Site.new
      parsed_site.address = row[5] + " " + row[6] + " " + row[7]+ ",Toronto" 
      parsed_site.description = row[16]
      parsed_site.contact_info = "Ash"
      parsed_site.status = row[15]
      parsed_site.type_of_property = row[18]

      parsed_site.save

      if(counter == 20)
        break
      end
    end

    #@sites = Site.search(params[:search])
    @sites = if params[:latitude] && params[:longitude]
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
      params.require(:site).permit(:address,:lattitude,:longitude,:description,:contact_info,:status, :type_of_property)
    end

    def load_site
      if params[:id] != nil
        @site = Site.find(params[:id])
      end
    end
end
