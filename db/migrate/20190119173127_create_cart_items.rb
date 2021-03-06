class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.references :product, foreign_key: true, on_delete: :cascade
      t.references :cart, foreign_key: true, on_delete: :cascade
      t.float :unit_price

      t.timestamps
    end
  end
end