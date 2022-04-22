class VideosController < ApplicationController

  def new
    @video = Video.new
  end

  def create

  end

  def show
    @video = Video.find_by_id(params[:id])
  end

end
