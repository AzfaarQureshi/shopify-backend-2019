class Resolvers::PurchaseCart < GraphQL::Function

	type Types::CartType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
		return GraphQL::ExecutionError.new("No Cart created, please create cart first") unless ctx[:current_cart]
		cart = Cart.find(ctx[:current_cart].id)
		cart.cart_items.each do |ci|
			Resolvers::PurchaseProduct.new.call(nil, {id: ci.product_id}, ctx)
		end
		cart.cart_status_id = 2
		cart.save!
		OpenStruct.new({
        id: cart.id,
        subtotal: cart.subtotal,
        cart_status: cart.cart_status,
        items: cart.cart_items.collect { |ci| ci.product }
      })
	end
end