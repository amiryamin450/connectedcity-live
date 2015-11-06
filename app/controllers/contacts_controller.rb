class ContactsController < ActionController::Base
  
  layout "static"

  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.new(params[:contact])
  	@contact.request = request

  	if @contact.deliver
  	  flash.now[:notice] = 'Thank you! Someone will respond shortly.'
  	else
  	  flash.now[:error] = 'Error sending message.'
  	end
  end
end