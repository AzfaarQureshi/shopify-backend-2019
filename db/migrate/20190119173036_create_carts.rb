class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.float :subtotal
      t.references :cart_status, foreign_key: true

      t.timestamps
    end
  end
end
