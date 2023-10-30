class BlogEntriesController < ApplicationController
  load_resource :location
  load_and_authorize_resource :blog_entry, through: [:location]

  # GET /blog_entries
  # GET /blog_entries.json
  def index
    @blog_entries = @location.blog_entries

    respond_to do |format|
      format.html
      format.json { render json: @blog_entries }
    end
  end

  # GET /blog_entries/1
  # GET /blog_entries/1.json
  def show
    @blog_entry = BlogEntry.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @blog_entry }
    end
  end

  # GET /blog_entries/new
  # GET /blog_entries/new.json
  def new
    @blog_entry = @location.blog_entries.new(user_id: current_user.id)
    respond_to do |format|
      format.html 
      format.json { render json: @blog_entry }
    end
  end

  # GET /blog_entries/1/edit
  def edit
    @blog_entry = BlogEntry.find(params[:id])
  end

  # POST /blog_entries
  # POST /blog_entries.json
  def create
    @blog_entry = @location.blog_entries.new(blog_entry_params)

    respond_to do |format|
      if @blog_entry.save
        format.html { redirect_to [@location, @blog_entry], notice: 'Blog entry was successfully created.' }
        format.json { render json: @blog_entry, status: :created, location: @blog_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @blog_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blog_entries/1
  # PUT /blog_entries/1.json
  def update
    @blog_entry = BlogEntry.find(params[:id])

    respond_to do |format|
      if @blog_entry.update_attributes(blog_entry_params)
        format.html { redirect_to [@location, @blog_entry], notice: 'Blog entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blog_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_entries/1
  # DELETE /blog_entries/1.json
  def destroy
    @blog_entry = BlogEntry.find(params[:id])
    @blog_entry.destroy

    respond_to do |format|
      format.html { redirect_to location_blog_entries_url }
      format.json { head :no_content }
    end
  end

  private

  def blog_entry_params
    params.require(:blog_entry).permit(:content, :location_id, :title, :user_id, :slug, :image)
  end
end
