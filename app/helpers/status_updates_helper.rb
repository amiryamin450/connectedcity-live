module StatusUpdatesHelper

  def statusable_path(statusable)
    case statusable.class.name
    when "RealEstateListing",  "NewHomeCommunity", "RentalProperty"
      [statusable.location, statusable]      
    else
      statusable
    end
  end
end
