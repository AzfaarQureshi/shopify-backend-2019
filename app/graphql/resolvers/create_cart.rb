class Resolvers::CreateCart < GraphQL::Function

	type Types::CartType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]
		cart_status = CartStatus.first
		cart = Cart.create!(cart_status: cart_status)
		ctx[:session][:cart_id] = cart.id
		OpenStruct.new({
			id: cart.id,
			subtotal: cart.subtotal,
			cart_status: cart_status,
			items: nil
		})

	end
end