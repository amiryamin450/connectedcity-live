class ManagersController < ApplicationController
  load_and_authorize_resource :location, find_by: :slug
  load_and_authorize_resource :manager, through: :location

  def new
    @manager = @location.managers.build
    handle_breadcrumbs
  end

  def create
    @manager = @location.managers.build
    @manager.creating_from_email!
    @manager.assign_attributes(new_manager_email: manager_params[:new_manager_email])

    if @manager.save
      ManagerMailer.new_manager_email(@location, @manager.user).deliver
      redirect_to edit_location_path(@location), flash: { success: "Success!" } and return
    else
      handle_breadcrumbs
      render :new
    end
  end

  def destroy
    @manager = Manager.find(params[:id])
    @manager.destroy

    redirect_to edit_location_path(@location), flash: { success: "Success!" } and return
  end

  private

  def manager_params
    params.require(:manager).permit!
  end

  def handle_breadcrumbs
    add_breadcrumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_breadcrumb "Editing #{@location.name}"
  end
end
