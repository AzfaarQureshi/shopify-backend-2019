require 'test_helper'

class Resolvers::ProductTest < ActiveSupport::TestCase
  def createProduct(args = {})
    Resolvers::CreateProduct.new.call(nil, args, {})
  end

  def purchaseProduct(args = {})
    Resolvers::PurchaseProduct.new.call(nil, args,  {})
  end

  def deleteProduct(args = {})
    Resolvers::DeleteProduct.new.call(nil, args, {})
  end

  test 'Product test' do
    product = createProduct(
      title: 'test product',
      price: 20.0,
      inventory_count: 1
    )

    assert product.persisted?
    assert_equal product.title, 'test product'
    assert_equal product.price, 20.0
    assert_equal product.inventory_count, 1
  end

  test 'Purchasing the test product' do
    product = Product.last
    old_inventory_count = product.inventory_count
    product = purchaseProduct(
      id: product.id
    )
    assert_equal product.inventory_count, old_inventory_count-1
  end

  test 'Deleting the test product' do
    p = Product.last
    product = deleteProduct(
      id: p.id
    )
    assert_equal Product.exists?(product.id), false

  end
end