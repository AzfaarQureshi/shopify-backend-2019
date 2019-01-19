class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validate :cart_present

  before_save :set_price


  private
	  def cart_present
	  	if cart.nil?
	  		errors.add(:cart, "is not a valid cart")
	  	end
	  end

	  def set_price
	  	self[:unit_price] = product.price
	  end
end
