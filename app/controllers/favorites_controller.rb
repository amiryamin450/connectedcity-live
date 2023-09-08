class FavoritesController < ApplicationController
  respond_to :js


  def create
    @favorite = Favorite.create({location_id: params[:location_id], user_id: current_user.id, category: params[:category]})
    current_user.connection.clear_query_cache
    @favorites = current_user.favorites.all
    @location = @favorite.location
    @btn = 'like_button_v2'

    render :toggle
  end

  def destroy
    favorite = Favorite.find(params[:id]).destroy
    current_user.connection.clear_query_cache
    @favorites = current_user.favorites.all
    @location = Location.unscoped.find(favorite.location_id)
    @btn = @location.is_profile ? 'user_follow_button' : 'like_button_v2'
    @vertical_market = VerticalMarket.new({:slug => favorite.category})
    render :toggle
  end

  def user_follow
    @location = Location.unscoped.find(params[:location_id])
    @favorite = Favorite.create({location_id: params[:location_id], user_id: current_user.id})
    @favorites = current_user.favorites
    @btn = 'user_follow_button'

    render :toggle
  end

end
