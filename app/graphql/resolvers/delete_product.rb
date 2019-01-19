class Resolvers::DeleteProduct < GraphQL::Function
	argument :id, !types.ID

	type Types::ProductType
	def call(_obj, args, _ctx)
		product = Product.find(args[:id])
		product.destroy
		product
		rescue ActiveRecord::RecordNotFound => e
			return GraphQL::ExecutionError.new "Product does not exist"
	end
end