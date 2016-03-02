module LocationMenusHelper
	def is_food_and_dining(location)
		if location.present?
			location.vertical_markets.each do |vertical_market|
				return true if vertical_market.ancestry.to_i == 2
			end

			false
		end
	end
end
