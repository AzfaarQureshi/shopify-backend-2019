class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validate :product_present
  validate :order_present

  before_save :set_price

  def unit_price
  	if persisted?
  		self[:unit_price]
  	end
end
