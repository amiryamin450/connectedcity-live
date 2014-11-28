class FavoritesController < ApplicationController
  respond_to :js


  def create
    @favorite = Favorite.create({:location_id => params[:location_id], :user_id => current_user.id, :category => params[:category]})
    current_user.connection.clear_query_cache
    @favorites = current_user.favorites.all
    @location = @favorite.location
    render :toggle
  end

  def destroy
    favorite = Favorite.find(params[:id]).destroy
    current_user.connection.clear_query_cache
    @favorites = current_user.favorites.all
    @location = favorite.location
    @vertical_market = VerticalMarket.new({:slug => favorite.category})
    render :toggle
  end



end
