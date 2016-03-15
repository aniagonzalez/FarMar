
class FarMar::Product
  attr_reader :id, :name, :vendor_id

  def initialize(vendor_hash)
    @id = vendor_hash[:id]
    @name = vendor_hash[:name]
    @vendor_id = vendor_hash[:vendor_id]
  end

  def self.all
    all_products = []
    CSV.foreach("support/products.csv", "r") do |line|
      all_products << self.new({:id => line[0], :name => line[1], :vendor_id => line[2]})
    end
    return all_products
  end

  def self.find(id)
    self.all.each do |product_inst|
      if product_inst.id.to_s == id.to_s
        return product_inst
      end
    end
    return false
  end

  def vendor
    # Returns the FarMar::Vendor instance that is associated with this vendor using the FarMar::Product vendor_id field
    FarMar::Vendor.all.find { |vendor| vendor.id == @vendor_id}
  end

  def sales
    # Returns a collection of FarMar::Sale instances that are associated using the FarMar::Sale product_id field.
    FarMar::Sale.all.find_all { |sale| sale.product_id == @id}
  end
end
