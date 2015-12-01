module ApplicationHelper
  def get_current_district
    if @district == nil
      current_district = @city
    else
      current_district = @district
    end
  end
end
