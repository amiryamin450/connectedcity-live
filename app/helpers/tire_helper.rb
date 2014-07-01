module TireHelper
  def search_for(*args, &block)
    tire.__send__(:search, *args, &block)    
  end
end