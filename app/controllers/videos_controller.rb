class VideosController < ApplicationController

  def create

  end

  def show
    @video = Video.find_by_id(params[:id])
  end

end
