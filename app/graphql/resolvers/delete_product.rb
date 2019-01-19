class Resolvers::DeleteProduct < GraphQL::Function
	argument :id, !types.ID

	type Types::ProductType
	def call(_obj, args, _ctx)
		# TODO error handling
		product = Product.find(args[:id])
		product.delete
		return product
	end
end