class ManagersController < ApplicationController
  load_and_authorize_resource :location, find_by: :slug
  load_and_authorize_resource :manager, through: :location

  def new
    @location = location
    @manager = @location.managers.build
    handle_breadcrumbs
  end

  def create
    @location = location
    @manager = @location.managers.build
    @manager.creating_from_email!
    @manager.assign_attributes(new_manager_email: params[:manager][:new_manager_email])

    if @manager.save
      ManagerMailer.new_manager_email(@location, @manager.user).deliver
      redirect_to edit_location_path(@location), flash: { success: "Success!" } and return
    else
      handle_breadcrumbs
      render :new
    end
  end

  def destroy
    @location = location

    @manager = Manager.find(params[:id])
    @manager.destroy

    redirect_to edit_location_path(@location), flash: { success: "Success!" } and return
  end

  private

  def handle_breadcrumbs
    add_breadcrumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_breadcrumb "Editing #{@location.name}"
  end

  def location
    @location ||= Location.find(params[:location_id])
  end

end
