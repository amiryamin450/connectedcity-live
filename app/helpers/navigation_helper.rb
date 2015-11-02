module NavigationHelper
  def setup_navigation
    @city = City.find(5915022)
    @districts = @city.districts
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb "#{@city.name} Guide"
  end
end