class BlogEntriesController < ApplicationController
  before_action :load_blog_entry, only: [:show, :edit, :update, :destroy]
  before_action :load_location, only: [:index, :new, :show, :edit, :create, :update, :destroy]
  load_resource :location, except: [:show, :edit]
  load_and_authorize_resource :blog_entry, through: [:location], except: [:show, :edit]
  layout "application_v_2"

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
  end

  # POST /blog_entries
  # POST /blog_entries.json
  def create
    @blog_entry = @location.blog_entries.new(blog_entry_params)

    respond_to do |format|
      if @blog_entry.save
        format.html { redirect_to action: :index, notice: 'Blog entry was successfully created.' }
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
    respond_to do |format|
      if @blog_entry.update(blog_entry_params)
        format.html { redirect_to action: :index, notice: 'Blog entry was successfully updated.' }
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
    @blog_entry.destroy

    respond_to do |format|
      format.html { redirect_to location_blog_entries_url }
      format.json { head :no_content }
    end
  end

  private

  def load_blog_entry
    @blog_entry ||= BlogEntry.unscoped.friendly.find(params[:id])
  end

  def load_location
    id_param = params[:location_id].presence || params[:id]
    @location = Location.unscoped.friendly.find(id_param)
  end

  def blog_entry_params
    params.require(:blog_entry).permit(:content, :title, :user_id, :image)
  end
end
