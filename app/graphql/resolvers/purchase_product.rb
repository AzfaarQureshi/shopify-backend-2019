class Resolvers::PurchaseProduct < GraphQL::Function
	argument :id, !types.ID

	type Types::ProductType
	def call(_obj, args, _ctx)
		prodToPurchase = Product.find(args[:id])
		# TODO add erorr handling if nil
		prodToPurchase.inventory_count -= 1
		prodToPurchase.save! # TODO if not true then return an error
		return prodToPurchase
	end
end