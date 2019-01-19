class Resolvers::AddToCart < GraphQL::Function

	argument :cart_id, !types.Int
	type Types::ProductType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:session][:token]

	end
end