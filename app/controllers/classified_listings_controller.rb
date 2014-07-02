class ClassifiedListingsController < ApplicationController

  load_and_authorize_resource :classified_listing
  # GET /classified_listings
  # GET /classified_listings.json
  def index

    @classified_listings = if user_signed_in?
      current_user.classified_listings
    else
      []
    end

    respond_to do |format|
      format.html # index.html.erb

    end
  end


  def guide
    @classified_categories = ClassifiedCategory.includes(:classified_listings).all
    add_crumb 'Classifieds'
  end

  # GET /classified_listings/1
  # GET /classified_listings/1.json
  def show

    add_crumb 'Classifieds', classifieds_path
    add_crumb @classified_listing.classified_category.name, classified_category_path(@classified_listing.classified_category)
    add_crumb @classified_listing.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @classified_listing.classified_images.map { |file| file.to_jq_upload } }
    end
  end

  # GET /classified_listings/new
  # GET /classified_listings/new.json
  def new
    @classified_listing = ClassifiedListing.new(active: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @classified_listing }
    end
  end

  # GET /classified_listings/1/edit
  def edit
  end

  # POST /classified_listings
  # POST /classified_listings.json
  def create
    @classified_listing = ClassifiedListing.new(params[:classified_listing])
    respond_to do |format|
      if @classified_listing.save
        format.html { render action: "edit" }
        format.json { render json: @classified_listing, status: :created, location: @classified_listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @classified_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classified_listings/1
  # PUT /classified_listings/1.json
  def update


    respond_to do |format|
      if @classified_listing.update_attributes(params[:classified_listing])
        format.html { redirect_to @classified_listing, notice: 'Classified listing was successfully updated.' }
        format.json { render json: { files: [@classified_listing.classified_images.last.to_jq_upload]}, status: :created, location: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @classified_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classified_listings/1
  # DELETE /classified_listings/1.json
  def destroy
    @classified_listing = ClassifiedListing.find(params[:id])
    @classified_listing.destroy

    respond_to do |format|
      format.html { redirect_to classified_listings_url }
      format.json { head :no_content }
    end
  end
end
