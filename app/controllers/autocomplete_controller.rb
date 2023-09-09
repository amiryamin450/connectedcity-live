class AutocompleteController < ApplicationController
  before_filter :authenticate_user
  # load_and_authorize_resource
  # Autocomplete isn't a valid model. ^FD 2015-08-14

  respond_to :js

  def users
    @users = User.order(:name).where('name like ?', "%%#{params[:term]}%%")
  end

end
