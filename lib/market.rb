
class FarMar::Market
  attr_reader :id, :name
  def initialize(market_hash)
    @id = market_hash[:id]
    @name = market_hash[:name]
    @address = market_hash[:address]
    @city = market_hash[:city]
    @county = market_hash[:county]
    @state = market_hash[:state]
    @zip = market_hash[:zip]
  end

  def self.all
    all_markets = []
    CSV.foreach("support/markets.csv", "r") do |line|
      all_markets << self.new({:id => line[0], :name => line[1], :address => line[2], :city => line[3], :county => line[4], :state => line[5], :zip => line[6]})
    end
    return all_markets
  end

  def self.find(id)
    self.all.each do |market_inst|
      if market_inst.id.to_s == id.to_s
        return market_inst
      end
    end
    return false
  end

  def vendors
    #Returns a collection of FarMar::Vendor instances that are associated with the market by the market_id field.
    FarMar::Vendor.all.find_all { |vendor| vendor.market_id == @id}
  end

  def products
    # Returns a collection of FarMar::Product instances that are associated to the market through the FarMar::Vendor class.
    # We can get with FarMar::Market - vendors an array of vendor instances
    # We can then get with FarMar::Vendor - products and array of products for each vendor
    vendors.collect { |vendor| vendor.products }
  end

  def self.search(search_term)
    # Returns a collection of FarMar::Market instances where the market name or vendor name contain the search_term
    results = []
    in_market_names = self.all.find_all { |market| market.name.downcase.include? search_term.downcase }
    results << in_market_names

    in_vendor_names = FarMar::Vendor.all.find_all { |vendor| vendor.name.downcase.include? search_term.downcase }
    results << in_vendor_names

    ### COMMENTED OUT BECAUSE THIS PREVIOUS METHOD TOOK 10+SECS ###
    #vendor_names = []
    #self.all.each do |market|
    #  results << market if market.name.downcase.include? search_term.downcase
    #  market.vendors.each do |vendor|
    #    if vendor.name.downcase.include? search_term.downcase
    #      vendor_names << market
    #    end
    #  end
    #end
    #results << vendor_names

    return results.flatten!
  end

  def preferred_vendor
    sorted = vendors.sort_by { |vendor| vendor.revenue }
    preferred = sorted.last
    puts "The preferred vendor is #{preferred.name} with a revenue of #{preferred.revenue}."
    return preferred
  end

  def worst_vendor
    sorted = vendors.sort_by { |vendor| vendor.revenue }
    worst = sorted.first
    puts "The worst vendor is #{worst.name} with a revenue of #{worst.revenue}."
    return worst
  end

end
