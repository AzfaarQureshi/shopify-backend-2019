class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validate :product_present
  validate :order_present
end
