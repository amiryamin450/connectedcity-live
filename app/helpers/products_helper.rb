module ProductsHelper
  def display_pricing product
  	if product.present?
	  if product.custom_pricing === true
	    "Call for Details"
	  else
	    number_to_currency product.price - product.discount
	  end
	else
	 ""
	end
  end
end
