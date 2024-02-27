class CarouselImagesController < ApplicationController
  load_and_authorize_resource
  before_action :get_carouselable


  # GET /carousel_images
  # GET /carousel_images.json
  def index
    @carousel_images = @carouselable.carousel_images 

    respond_to do |format|
      format.html
      format.json { render json: @carousel_images }
    end
  end

  # GET /carousel_images/1
  # GET /carousel_images/1.json
  def show
    @carousel_image = CarouselImage.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @carousel_image }
    end
  end

  # GET /carousel_images/new
  # GET /carousel_images/new.json
  def new
    @carousel_image = @carouselable.carousel_images.new

    respond_to do |format|
      format.html 
      format.json { render json: @carousel_image }
    end
  end

  # GET /carousel_images/1/edit
  def edit
    @carousel_image = CarouselImage.find(params[:id])
  end

  # POST /carousel_images
  # POST /carousel_images.json
  def create
    @carousel_image = @carouselable.carousel_images.new(carousel_image_params)

    respond_to do |format|
      if @carousel_image.save
        format.html { redirect_to polymorphic_url([@carouselable, :carousel_images]), notice: 'Carousel image was successfully created.' }
        format.json { render json: @carousel_image, status: :created, location: @carousel_image }
      else
        format.html { render action: "new" }
        format.json { render json: @carousel_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /carousel_images/1
  # PUT /carousel_images/1.json
  def update
    @carousel_image = CarouselImage.find(params[:id])

    respond_to do |format|
      if @carousel_image.update(carousel_image_params)
        format.html { redirect_to polymorphic_url([@carouselable, :carousel_images]), notice: 'Carousel image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @carousel_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carousel_images/1
  # DELETE /carousel_images/1.json
  def destroy
    @carousel_image = CarouselImage.find(params[:id])
    @carousel_image.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_url([@carouselable, :carousel_images]) }
      format.json { head :no_content }
    end
  end


  private

  def get_carouselable
    @carouselable = params[:carouselable].classify.constantize.find(carouselable_id)
  end

  def carouselable_id
    params[(params[:carouselable].singularize + "_id").to_sym]
  end

  def carousel_image_params
    params.require(:carousel_image).permit(:caption, :title, :image, :url)
  end
end
