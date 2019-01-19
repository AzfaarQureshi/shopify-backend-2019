Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :allProducts, !types[Types::ProductType] do
    argument :available_inventory_only, types.Boolean
    resolve -> (obj, args, ctx) {
      return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
      if(args[:available_inventory_only])
        return Product.where("inventory_count > ? ", 0)
      else
        return Product.all
      end
    }
  end

  field :getProduct, Types::ProductType do
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
      if(Product.exists?(args[:id]))
        return Product.find(args[:id])
      else
        return GraphQL::ExecutionError.new "Product does not exist with id: #{args[:id]}"
      end
    }
  end

  field :getCart, Types::CartType do
    resolve -> (obj, args, ctx) {
      return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
      return GraphQL::ExecutionError.new("Create active cart first") unless ctx[:current_cart]
      cart = Cart.find(ctx[:current_cart].id)
      OpenStruct.new({
        id: cart.id,
        subtotal: cart.subtotal,
        cart_status: cart.cart_status,
        items: cart.cart_items.collect { |ci| ci.product }
      })
    }
  end
end
