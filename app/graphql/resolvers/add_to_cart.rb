class Resolvers::AddToCart < GraphQL::Function

	argument :cart_id, !types.Int
	argument :product_ids, !types[types.Int]

	type Types::CartType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
		cart = Cart.find(args[:cart_id])
		args[:product_ids].each do |pid|
			prod = Product.find(pid)
			cart.cart_items.create(product_id: pid)
		end
		cart.save!
		resp = OpenStruct.new({
			id: cart.id,
			subtotal: cart.subtotal,
			cart_status: cart.cart_status,
			items: cart.cart_items.collect { |ci| ci.product }
		})

	end
end