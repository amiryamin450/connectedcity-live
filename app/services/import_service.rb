class ImportService
  def initialize(request)
    @request = request
  end

  def import!
    send "import_#{@request.kind}"
  end

  def import_agents
    messages = Array.new
    errors = Array.new
    success_count = 0
    begin
      CSV.foreach(@request.csv.tempfile, encoding: 'iso-8859-1:utf-8') do |row|
        unless row.count == 8
          raise "please ensure your CSV file has the appropriate number of columns, and try again."
        end

        # first check for duplicates (matching name and address)
        name, broker, address, _, postal_code, phone, _, website_url = row

        if Location.exists?(name: name, address: address)
          messages << "Row #{$.}: Duplicate listing for #{row[0]} at #{row[2]}."
          next
        end

        broker = Location.where(name: broker, address: address).first
        unless broker
          messages << "Row #{$.}: Could not find broker #{row[1]} at #{row[2]}."
          next
        end

        # works to specifically catch issues matching a lat/lng with a neighbourhood so the import can continue
        begin

          # light error checking done (feature is admin use only), build the location
          location = Location.create  name: name,
                                      address: address,
                                      broker_id: broker.id,
                                      city_id: 5915022,
                                      province_id: 59,
                                      country_id: 1,
                                      postal_code: postal_code,
                                      vertical_market_category_ids: [99],
                                      district_id: broker.district_id,
                                      phone: phone,
                                      website_url: website_url
        rescue => e
          messages << "Row #{$.}: Unable to save #{row[0]} at #{row[2]} - #{e.message}"
          next
        end

        if location.persisted?
          success_count+=1
        else
          messages << "Row #{$.}: Unable to save #{row[0]} at #{row[2]}."
        end
      end

      response = Success.new(messages, success_count)
    rescue RuntimeError => e
      response = Error.new("There was an error during import – #{e.message}")
    rescue => e
      response = Error.new("There was an error during import – please ensure you upload a valid CSV file, and try again. #{e.message}")
    end
  end

  def import_businesses
    messages = Array.new
    errors = Array.new
    success_count = 0
    begin
      CSV.foreach(@request.csv.tempfile, encoding: 'iso-8859-1:utf-8') do |row|
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

        # works to specifically catch issues matching a lat/lng with a neighbourhood so the import can continue
        begin

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
        rescue => e
          messages << "Row #{$.}: Unable to save #{row[0]} at #{row[1]} - #{e.message}"
          next
        end

        if location.persisted?
          success_count+=1
        else
          messages << "Row #{$.}: Unable to save #{row[0]} at #{row[1]}."
        end
      end

      response = Success.new(messages, success_count)
    rescue RuntimeError => e
      response = Error.new("There was an error during import – #{e.message}")
    rescue => e
      response = Error.new("There was an error during import – please ensure you upload a valid CSV file, and try again. #{e.message}")
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
