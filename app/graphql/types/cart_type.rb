Types::CartType = GraphQL::ObjectType.define do
	name 'Cart'

	#Fields of Cart
	field :id, !types.ID
	field :subtotal, !types.Float
	field :cart_status, !Types::CartStatusType
	field :items, Types::ProductType
end