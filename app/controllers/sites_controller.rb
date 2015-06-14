class SitesController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_site


  def index
    
    require 'csv'
    require 'rest-client'

    # CSV.foreach(Rails.root + "app/assets/csv/activepermits2.csv") do |row|
    #   counter += 1

    #   parsed_site = Site.new
    #   parsed_site.address = row[5] + " " + row[6] + " " + row[7]+ ",Toronto" 
    #   parsed_site.description = row[16]
    #   parsed_site.contact_info = "Ash"
    #   parsed_site.status = row[15]
    #   parsed_site.type_of_property = row[18]

    #   parsed_site.save

    #   if(counter == 20)
    #     break
    #   end
    # end
    require 'json'
    require 'csv'

    data_json = RestClient.get 'http://data.ottawa.ca/api/action/datastore_search?resource_id=a8ff7c33-1392-4943-9399-5a130ff27ecf', {:accept => :json}
    data = JSON.parse(data_json)

    records = data["result"]["records"]

    offset = data["result"]["offset"]
    total = data["result"]["total"]

    # # Get rest of data
    # counter = 1
    # until (offset <= total) do
    #   data_json[counter] = RestClient.get 'http://data.ottawa.ca/api/action/datastore_search?offset=100&resource_id=a8ff7c33-1392-4943-9399-5a130ff27ecf', {:accept => :json}
    #   data[counter] = JSON.parse(data_json)
    #   records[counter] = data["result"]["records"]
    #   offset = data[counter]["result"]["offset"]
    #   counter += 1
    # end 

    # # Put in database
    # i = 0
    # until (i <= counter)
      records.each do |rec|
        single_rec = Site.new
        single_rec.address = rec["ST #"] + rec["ROAD"] + ", " + rec["MUNICIPALITY"] + ", Ottawa"
        single_rec.description = rec["DESCRIPTION"]
        single_rec.contact_info = rec["CONTRACTOR"]
        single_rec.status = rec["APPL. TYPE"]
        single_rec.type_of_property = ["BLG TYPE"]

        single_rec.save
      end
    # end


    csv_string = CSV.generate do |csv|
      records.each do |hash|
        csv << hash.values
      end
    end

    File.write(Rails.root + "app/assets/csv/records.csv", csv_string)

    @sites = Site.all

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
