class Cart < ApplicationRecord
  belongs_to :cart_status
  has_many :cart_items
  before_save :update_subtotal

  def subtotal
  	cart_items.collect { |ci| ci.valid? ? ci.unit_price : 0}.sum
  end

  private

  def update_subtotal
  	self[:subtotal] = subtotal
  end

end
