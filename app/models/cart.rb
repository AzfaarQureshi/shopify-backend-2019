class Cart < ApplicationRecord
  belongs_to :cart_status
  has_many :cart_items
  before_create :set_cart_status
  before_save :update_subtotal

  def subtotal
  	cart_items.collect { |ci| ci.valid? ? ci.unit_price : 0}.sum
  end

  private

  def update_subtotal
  	self[:subtotal] = subtotal
  end

  def set_cart_status
  	self.cart_status_id = 1
  end
end
