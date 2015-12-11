module ProductsHelper
  def display_pricing
    if @product.custom_pricing.true?
      "Call for Details"
    else
      number_to_currency @product.price
    end
  end
end
