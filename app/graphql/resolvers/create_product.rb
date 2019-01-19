class Resolvers::CreateProduct < GraphQL::Function
	argument :title, !types.String
	argument :price, !types.Float
	argument :inventory_count, !types.Int

	type Types::ProductType
	def call(_obj, args, ctx)
		return GraphQL::ExecutionError.new("Not Authorized to make this request") unless ctx[:current_user].role == "[\"ADMIN_USER\"]"
		Product.create!(
			title: args[:title],
			price: args[:price],
			inventory_count: args[:inventory_count]
		)
		rescue ActiveRecord::RecordInvalid => e
    		GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
	end
end