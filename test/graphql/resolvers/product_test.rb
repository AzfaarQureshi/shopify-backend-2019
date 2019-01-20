require 'test_helper'

class Resolvers::ProductTest < ActiveSupport::TestCase
  def createProduct(args = {}, curr = nil)
    Resolvers::CreateProduct.new.call(nil, args, { session: { token: "123123"}, current_user: curr })
  end

  def purchaseProduct(args = {}, curr = nil)
    Resolvers::PurchaseProduct.new.call(nil, args,  {session: { token: "123123"}, current_user: curr })
  end

  def deleteProduct(args = {}, curr = nil)
    Resolvers::DeleteProduct.new.call(nil, args, { session: { token: "123123"}, current_user: curr})
  end
  setup do
    args = {
      name: 'Example Admin User',
      role: "[\"ADMIN_USER\"]",
      authProvider: {
        email: {
          email: 'test@example.com',
          password: 'Some Password'
        }
      }
    }
    @user = Resolvers::CreateUser.new.call(nil, args, nil)
  end
  test 'Product test' do
    product = createProduct({
      title: 'test product',
      price: 20.0,
      inventory_count: 1
    }, @user
    )

    assert product.persisted?
    assert_equal product.title, 'test product'
    assert_equal product.price, 20.0
    assert_equal product.inventory_count, 1
  end

  test 'Purchasing the test product' do
    product = Product.last
    old_inventory_count = product.inventory_count
    product = purchaseProduct({
      id: product.id
    }, @user
    )
    assert_equal product.inventory_count, old_inventory_count-1
  end

  test 'Deleting the test product' do
    p = Product.last
    product = deleteProduct({
      id: p.id
    }, @user
    )
    assert_equal Product.exists?(product.id), false

  end
end