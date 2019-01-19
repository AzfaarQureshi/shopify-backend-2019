class Resolvers::PurchaseProduct < GraphQL::Function
	argument :id, !types.ID

	type Types::ProductType
	def call(_obj, args, _ctx)
		if(Product.exists?(args[:id]))
			prodToPurchase = Product.find(args[:id])
			if (prodToPurchase.inventory_count > 0)
				prodToPurchase.inventory_count -= 1
			else
				return GraphQL::ExecutionError.new "Cannot purchase product with inventory_count 0!"
			end

			if (prodToPurchase.save!)
				return prodToPurchase
			else
				return GraphQL::ExecutionError.new "500 internal server error"
			end
		else
			return GraphQL::ExecutionError.new "Product does not exist"
		end
	end
end