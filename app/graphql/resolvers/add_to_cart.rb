class Resolvers::AddToCart < GraphQL::Function

	argument :product_ids, !types[types.Int]

	type Types::CartType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
		return GraphQL::ExecutionError.new("No Cart created, please create cart first") unless ctx[:current_cart]
		cart = Cart.find(ctx[:current_cart].id)
		args[:product_ids].each do |pid|
			prod = Product.find(pid)

			cart.cart_items.create(product_id: pid)
		end
		cart.save!
		ctx[:session][:current_cart] = nil
		resp = OpenStruct.new({
			id: cart.id,
			subtotal: cart.subtotal,
			cart_status: cart.cart_status,
			items: cart.cart_items.collect { |ci| ci.product }
		})
		rescue ActiveRecord::RecordNotFound => e
			GraphQL::ExecutionError.new "Invalid  product id given"
	end
end