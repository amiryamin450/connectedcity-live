class ImportService
  def initialize(params)
    begin
      @file = params[:csv]
    rescue
      response = Error.new("Please ensure you upload a valid CSV file, and try again.")
    end
  end

  def import_businesses
    messages = Array.new
    errors = Array.new
    success_count = 0
    begin
      CSV.foreach(@file.tempfile) do |row|
        unless row.count == 14
          raise "please ensure your CSV file has the appropriate number of columns, and try again."
        end

        # first check for duplicates (matching name and address)
        name, address, _, district_suffix, _, _, postal_code, _, _, phone, _, _, vertical_market_category, website_url = row

        if Location.exists?(name: name, address: address)
          messages << "Row #{$.}: Duplicate listing for #{row[0]} at #{row[1]}."
          next
        end

        # ensure we have a vertical market category
        vertical_market_category_id = VerticalMarketCategory.where(name: row[12]).pluck("id").first
        unless vertical_market_category_id.present?
          messages << "Row #{$.}: Couldn't find a matching vertical market for '#{row[12]}' for #{row[0]} at #{row[1]}."
          next
        end

        # ensure we have a district_id
        district_id = District.where(slug: "vancouver-#{row[3].downcase}").pluck("id").first
        unless district_id.present?
          messages << "Row #{$.}: Couldn't find a matching district for '#{row[3]}' for #{row[0]} at #{row[1]}."
          next
        end

        # light error checking done (feature is admin use only), build the location
        location = Location.create  name: row[0],
                                    address: row[1],
                                    city_id: 5915022,
                                    province_id: 59,
                                    country_id: 1,
                                    postal_code: row[6],
                                    vertical_market_category_ids: [vertical_market_category_id],
                                    district_id: district_id,
                                    phone: row[9],
                                    website_url: row[13]

        if location.persisted?
          success_count+=1
        else
          messages << "Row #{$.}: Unable to save #{row[0]} at #{row[1]}."
        end
      end

      response = Success.new(messages, success_count)
    rescue RuntimeError => e
      response = Error.new("There was an error during import – #{e.message}")
    rescue
      response = Error.new("There was an error during import – please ensure you upload a valid CSV file, and try again.")
    end
  end
end

class ServiceResponse
  def success?
    false
  end
end

class Success < ServiceResponse
  attr_reader :data
  attr_reader :success_count
  def initialize(data, success_count)
    @data = data
    @success_count = success_count
  end

  def success?
    true
  end
end

class Error < ServiceResponse
  attr_reader :error
  def initialize(error)
    @error = error
  end
end
