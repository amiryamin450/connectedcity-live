module BusinessImprovementAreasHelper
  def get_current_bia
    if params[:id]
      @business_improvement_area
    end
  end
end
