module ApplicationHelper
  def get_current_district
    # if @district == nil
    #   current_district = @city
    # else
    #   current_district = @district
    # end
    current_district = @municipality if @municipality
    current_district = @city if @city
    current_district = @district if @district
    current_district = @neighborhood if @neighborhood
    current_district = @sub_neighborhood if @sub_neigborhood
    current_district
  end
end
