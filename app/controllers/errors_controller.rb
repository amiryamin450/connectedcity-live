class ErrorsController < ApplicationController
  def show
    response.status = request.path[1..-1]
    render action: request.path[1..-1]
  end
end
