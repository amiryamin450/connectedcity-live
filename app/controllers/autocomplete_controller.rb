class AutocompleteController < ApplicationController
  respond_to :js

  def users
    @users = User.order(:name).where('name like ?', "%%#{params[:term]}%%")
  end

end