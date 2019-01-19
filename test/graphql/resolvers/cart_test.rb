require 'test_helper'

class Resolvers::CreateCartTest < ActiveSupport::TestCase
  def createCart(args = {})
    Resolvers::CreateCart.new.call(nil, args, {session: {}})
  end

  test 'creating new cart' do
    cart = createCart()
    assert_not_nil cart
  end
end