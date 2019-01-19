class Product < ApplicationRecord
	validates :title, presence: true
	validates :price, presence: true
	validates :inventory_count, presence: true

	has_many :cart_items, dependent: :destroy
end
