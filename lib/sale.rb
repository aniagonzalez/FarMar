
class FarMar::Sale
  attr_reader

  def initialize(id, amount, purchase_time, vendor_id, product_id)
    @id = id
    @amount = amount
    @purchase_time = purchase_time
    @vendor_id = vendor_id
    @product_id = product_id

  end

end